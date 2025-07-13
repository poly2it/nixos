{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    # `l`: locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
    # `r`: release, will trigger on release of a key.
    # `c`: click, will trigger on release of a key or button as long as the mouse cursor stays inside binds:drag_threshold.
    # `g`: drag, will trigger on release of a key or button as long as the mouse cursor moves outside binds:drag_threshold.
    # `o`: longPress, will trigger on long press of a key.
    # `e`: repeat, will repeat when held.
    # `n`: non-consuming, key/mouse events will be passed to the active window in addition to triggering the dispatcher.
    # `m`: mouse, see below.
    # `t`: transparent, cannot be shadowed by other binds.
    # `i`: ignore mods, will ignore modifiers.
    # `s`: separate, will arbitrarily combine keys between each mod/key
    # `d`: has description, will allow you to write a description for your bind.
    # `p`: bypasses the app's requests to inhibit keybinds.
    bindl = [
      ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise 5%+"
      ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower 5%-"
      "$mod, XF86MonBrightnessUp, exec, brightnessctl set 100%"
      "$mod, XF86MonBrightnessDown, exec, brightnessctl set 0%"
      "CAPS,Caps_Lock,exec,swayosd-client --caps-lock"
    ];
    bindle = [
      ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume +5 --max-volume=100"
      ",XF86AudioLowerVolume, exec, swayosd-client --output-volume -5"

      "$mod, f11, exec, swayosd-client --output-volume +5 --max-volume=100"
      "$mod, f12, exec, swayosd-client --output-volume -5"
    ];
    bindr = [
      ",Scroll_Lock,exec,swayosd-client --scroll-lock"
      ",Num_Lock,exec,swayosd-client --num-lock"
    ];
    bind = [
      "$mod, F, exec, firefox"
      "$mod, return, exec, kitty --title kitty"
      "$mod, space, exec, anyrun"
      "$mod, B, exec, ${pkgs.grimblast}/bin/grimblast save screen ${config.xdg.userDirs.pictures}/screenshots/$(date +'%Y-%m-%dT%H:%M:%S%z').png"
      "$mod, N, exec, ${pkgs.grimblast}/bin/grimblast save area ${config.xdg.userDirs.pictures}/screenshots/$(date +'%Y-%m-%dT%H:%M:%S%z').png"

      "$mod, C, killactive"
      "$mod, O, fullscreen"

      "$mod, V, exec, hyprctl dispatch togglefloating"

      "$mod, h, movefocus, l"
      "$mod, j, movefocus, d"
      "$mod, k, movefocus, u"
      "$mod, l, movefocus, r"

      ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
    ] ++ (
      builtins.concatLists (builtins.genList (i: [
        "$mod, code:1${toString i}, workspace, ${toString (i + 1)}"
        "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString (i + 1)}"
      ]) 9)
    );
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
    input.kb_layout = "se,us";
    monitor = "DP-1, 1920x1080@165.00Hz, 0x0, 1";
    general = {
      border_size = 0;
      no_border_on_floating = true;
    };
    decoration.blur = {
      enabled = true;
      passes = 4;
      size = 12;
      noise = 0.015;
      brightness = 2.0;
      vibrancy = 0.11;
      ignore_opacity = true;
    };
    decoration.shadow = {
      enabled = true;
      range = 24;
      render_power = 2;
      color = "0x1f1a1a1a";
    };
    decoration.rounding = 12;
    decoration.rounding_power = 2.0;
    dwindle = {
      pseudotile = true;
    };
    general.resize_on_border = true;
    xwayland.force_zero_scaling = true;
  };
  wayland.windowManager.hyprland.extraConfig = ''
    env = XCURSOR_THEME,Adwaita
    env = XCURSOR_SIZE,24
    exec-once = hyprctl setcursor Adwaita 24
    exec-once = kitty --title KITTY_SINGLE_INSTANCE --single-instance
    exec-once = swaybg --image ${config.xdg.userDirs.pictures}/wallpapers/rosebushes_under_trees.png

    env = NIXOS_OZONE_WL,1
    env = GDK_BACKEND,wayland,x11,*
    env = QT_QPA_PLATFORM,wayland;xcb
    env = SDL_VIDEODRIVER,wayland
    env = CLUTTER_BACKEND,wayland

    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland
    env = XDG_SESSION_DESKTOP,Hyprland

    env = QT_AUTO_SCREEN_SCALE_FACTOR,1
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1

    env = GBM_BACKEND,nvidia-drm
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    env = LIBVA_DRIVER_NAME,nvidia

    layerrule = blur, anyrun
    layerrule = ignorealpha 0.3, anyrun
    layerrule = noanim, anyrun

    bezier = almostLinear, 0.48, 0.79, 0.56, 1
    animation = windows, 0, 100, almostLinear, slidefade 10%
    animation = windowsIn, 1, 1, almostLinear, slide down 100px

    windowrulev2 = noinitialfocus, initialClass:kitty, initialTitle:KITTY_SINGLE_INSTANCE
    windowrulev2 = float, initialClass:kitty, initialTitle:KITTY_SINGLE_INSTANCE
    windowrulev2 = suppressevent fullscreen maximize activate activatefocus, initialClass:kitty, initialTitle:KITTY_SINGLE_INSTANCE
    windowrulev2 = size 0 0, initialClass:kitty, initialTitle:KITTY_SINGLE_INSTANCE
    windowrulev2 = move -1024 -1024, initialClass:kitty, initialTitle:KITTY_SINGLE_INSTANCE

    # Thunderbird unread mail notifier.
    # windowrulev2 = noinitialfocus, initialClass:thunderbird, initialTitle:, title:
    # windowrulev2 = float, initialClass:thunderbird, initialTitle:, title:
    # windowrulev2 = pin, initialClass:thunderbird, initialTitle:, title:
    # windowrulev2 = move 100%-w- 0%, initialClass:thunderbird, initialTitle:, title:

    # Firefox PiP
    windowrulev2 = noinitialfocus, class:firefox-nightly title:Picture-in-Picture
    windowrulev2 = float, class:firefox-nightly title:Picture-in-Picture
    windowrulev2 = pin, class:firefox-nightly title:Picture-in-Picture
    windowrulev2 = size 25% 25%, class:firefox-nightly title:Picture-in-Picture
    windowrulev2 = move 100%-w-20 20, class:firefox-nightly title:Picture-in-Picture

    windowrulev2 = float,title:development.float
    windowrulev2 = size 80% 80%, title:development.float
    windowrulev2 = move 10% 10%, title:development.float

    # Steam notifications.
    windowrulev2 = pin, initialTitle:notificationtoasts_([0-9]+)_desktop, class:steam

    windowrulev2 = float, class:xdg-desktop-portal-gtk

    windowrulev2 = float, class:org.x.GnomeOnlineAccountsGtk

    windowrulev2 = float, initialTitle:Sign into Modrinth

    windowrulev2 = size 50% 50%, initialTitle:raylib
    windowrulev2 = float, initialTitle:raylib

    windowrulev2 = float, class:org.gnome.FileRoller

    # Ghidra
    windowrulev2 = float, class:ghidra-Ghidra title:"Tip of the Day"
    windowrulev2 = tile, class:ghidra-Ghidra title:"Ghidra: .*"
  '';
}

