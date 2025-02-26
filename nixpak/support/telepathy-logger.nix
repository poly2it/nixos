{ pkgs }:

pkgs.telepathy-logger.overrideAttrs (prev: {
  env.CFLAGS = "-Wno-error=incompatible-pointer-types";
})

