package main

import (
	"crypto/x509"
	"encoding/pem"
	"flag"
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"time"

	"github.com/fsnotify/fsnotify"
)

type Config struct {
	BaseBundle     string
	DynamicDir     string
	OutputBundle   string
	RebuildOnStart bool
}

func main() {
	cfg := Config{}
	flag.StringVar(&cfg.BaseBundle, "base-bundle", "", "Path to base CA bundle")
	flag.StringVar(&cfg.DynamicDir, "dynamic-dir", "/var/lib/dynamic-certs", "Directory to watch for certificates")
	flag.StringVar(&cfg.OutputBundle, "output", "/run/dynamic-ca/ca-bundle.crt", "Output path for merged bundle")
	flag.BoolVar(&cfg.RebuildOnStart, "rebuild-on-start", true, "Rebuild bundle on startup")
	flag.Parse()

	if cfg.BaseBundle == "" {
		slog.Error("base-bundle is required")
		os.Exit(1)
	}

	logger := slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
		Level: slog.LevelInfo,
	}))
	slog.SetDefault(logger)

	if cfg.RebuildOnStart {
		if err := rebuildBundle(cfg); err != nil {
			slog.Error("failed to build initial bundle", "error", err)
			os.Exit(1)
		}
	}

	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		slog.Error("failed to create watcher", "error", err)
		os.Exit(1)
	}
	defer watcher.Close()

	if err := watcher.Add(cfg.DynamicDir); err != nil {
		slog.Error("failed to watch directory", "error", err, "path", cfg.DynamicDir)
		os.Exit(1)
	}

	slog.Info("watching for certificate changes", "directory", cfg.DynamicDir)

	for {
		select {
		case event, ok := <-watcher.Events:
			if !ok {
				return
			}

			ext := filepath.Ext(event.Name)
			if ext != ".crt" && ext != ".pem" {
				continue
			}

			slog.Info("detected change", "event", event.Op.String(), "file", event.Name)

			if err := rebuildBundle(cfg); err != nil {
				slog.Error("failed to rebuild bundle", "error", err)
			}

		case err, ok := <-watcher.Errors:
			if !ok {
				return
			}
			slog.Error("watcher error", "error", err)
		}
	}
}

func rebuildBundle(cfg Config) error {
	start := time.Now()

	var bundle []byte

	baseData, err := os.ReadFile(cfg.BaseBundle)
	if err != nil {
		return fmt.Errorf("read base bundle: %w", err)
	}
	bundle = append(bundle, baseData...)

	certCount := 0
	validCerts := 0
	entries, err := os.ReadDir(cfg.DynamicDir)
	if err != nil {
		return fmt.Errorf("read dynamic directory: %w", err)
	}

	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}

		ext := filepath.Ext(entry.Name())
		if ext != ".crt" && ext != ".pem" {
			continue
		}

		certPath := filepath.Join(cfg.DynamicDir, entry.Name())
		certCount++

		certData, err := os.ReadFile(certPath)
		if err != nil {
			slog.Warn("failed to read certificate", "error", err, "path", certPath)
			continue
		}

		if !validateCertificate(certData) {
			slog.Warn("invalid certificate format", "path", certPath)
			continue
		}

		bundle = append(bundle, '\n')
		bundle = append(bundle, certData...)

		validCerts++
		slog.Debug("added certificate", "path", certPath)
	}

	if err := os.WriteFile(cfg.OutputBundle, bundle, 0644); err != nil {
		return fmt.Errorf("write output bundle: %w", err)
	}

	duration := time.Since(start)
	slog.Info("certificate bundle rebuilt",
		"total_certs", certCount,
		"valid_certs", validCerts,
		"duration_ms", duration.Milliseconds(),
		"output", cfg.OutputBundle,
	)

	return nil
}

func validateCertificate(data []byte) bool {
	rest := data
	foundCert := false

	for {
		block, remainder := pem.Decode(rest)
		if block == nil {
			break
		}

		if block.Type == "CERTIFICATE" {
			if _, err := x509.ParseCertificate(block.Bytes); err == nil {
				foundCert = true
			}
		}

		rest = remainder
		if len(rest) == 0 {
			break
		}
	}

	return foundCert
}
