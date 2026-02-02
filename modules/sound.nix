{ ... }:

{
  # Real-time audio.
  security.rtkit.enable = true;

  # Disable PulseAudio.
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 2048;
        "default.clock.min-quantum" = 2048;
        "default.clock.max-quantum" = 8192;
      };
    };
    extraConfig.pipewire = {
      "10-mono-loopback" = {
        "context.modules" = [
          {
            name = "libpipewire-module-loopback";
            args = {
              "capture.props" = {
                "audio.position" = [ "FL" "FL" ];
                "node.target" = "alsa_input.usb-Focusrite_Scarlett_2i2_USB-00.Direct__Direct__source";
              };
              "playback.props" = {
                "node.name" = "mono-microphone";
                "node.description" = "Mono Microphone (Left Channel)";
                "media.class" = "Audio/Source";
                "audio.position" = [ "MONO" ];
              };
            };
          }
        ];
      };
    };
  };

  systemd.user.services.pipewire.serviceConfig = {
    # Highest real-time priority.
    LimitRTPRIO = 99;
    # Unlimited memory pages.
    LimitMEMLOCK = "infinity";
    # Highest scheduling priority.
    LimitNICE = "-20";
  };

  # Hardware priority for Zrythm.
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "soft";
      value = "99999";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "hard";
      value = "99999";
    }
  ];

  services.udev.extraRules = ''
    KERNEL=="rtc0", GROUP="audio"
    KERNEL=="hpet", GROUP="audio"
  '';
}
