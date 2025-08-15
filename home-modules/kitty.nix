{ ... }: let
	bg = "#ffffff";
	fg = "#191919";

	black = "#000000";
	red = "#e5492b";
	green = "#50d148";
	yellow = "#c6c440";
	blue = "#3b75ff";
	magenta = "#ed66e8";
	cyan = "#4ed2de";
	white = "#dcdcdc";

	bright_black = "#9f9f9f";
	bright_red = "#ff6640";
	bright_green = "#61ef57";
	bright_yellow = "#f2f156";
	bright_blue = "#0082ff";
	bright_magenta = "#ff7eff";
	bright_cyan = "#61f7f8";
	bright_white = "#f2f2f2";

	cursor = "#4d4d4d";
	selection = "#c1ddff";
in {
  programs.kitty = {
    enable = true;
    font = {
      name = "IBM Plex Mono";
      size = 11;
    };
    extraConfig = ''
      text_composition_strategy legacy

      placement_strategy top-left

      modify_font underline_position 22

      url_color #ffffff
      url_style straight

      copy_on_select no

      strip_trailing_spaces smart

      repaint_delay 6
      input_delay 3
      sync_to_monitor yes

      enable_audio_bell no

      # If only there were draggable window corners.
      hide_window_decorations yes

      tab_bar_edge bottom

      tab_bar_margin_width 0.0
      tab_bar_margin_height 0.0 0.0

      tab_bar_style separator
      tab_separator ""

      tab_title_template " {tab.active_exe} {title} {index} "

      active_tab_foreground   #ffffff
      active_tab_background   #3a3a3a
      active_tab_font_style   normal
      inactive_tab_foreground #8e8e8e
      inactive_tab_background #1e1e1e
      inactive_tab_font_style normal

      tab_bar_background #1e1e1e

      window_margin_width 0
      window_padding_width 0

      wayland_titlebar_color background

      map ctrl+alt+1 goto_tab 1
      map ctrl+alt+2 goto_tab 2
      map ctrl+alt+3 goto_tab 3
      map ctrl+alt+4 goto_tab 4
      map ctrl+alt+5 goto_tab 5
      map ctrl+alt+6 goto_tab 6
      map ctrl+alt+7 goto_tab 7
      map ctrl+alt+8 goto_tab 8
      map ctrl+alt+9 goto_tab 9

      # Seti-UI + Custom
      symbol_map U+E5FA-U+E62B Symbols Nerd Font
      # Devicons
      symbol_map U+E700-U+E7C5 Symbols Nerd Font
      # Font Awesome
      symbol_map U+F000-U+F2E0 Symbols Nerd Font
      # Font Awesome Extension
      symbol_map U+E200-U+E2A9 Symbols Nerd Font
      # Material Design Icons
      symbol_map U+F0001-U+F1AF0 Symbols Nerd Font
      # Weather
      symbol_map U+E300-U+E3E3 Symbols Nerd Font
      # Octicons
      symbol_map U+F400-U+F532,U+2665-U+26A1 Symbols Nerd Font
      # Powerline Extra Symbols
      symbol_map U+E0A0-U+E0A2,U+E0B0-U+E0B3 Symbols Nerd Font
      # IEC Power Symbols
      symbol_map U+23FB-U+23FE,U+2B58 Symbols Nerd Font
      # Font Logos
      symbol_map U+F300-U+F372 Symbols Nerd Font
      # Pomicons
      symbol_map U+E000-U+E00A Symbols Nerd Font
      # Codicons
      symbol_map U+E060-U+EBEB Symbols Nerd Font
      # Heavy Angle Brackets
      symbol_map U+E276C-U+E2771 Symbols Nerd Font
      # Box Drawing
      symbol_map U+2500-U+259F Symbols Nerd Font

      cursor ${cursor}
      foreground ${fg}
      background ${bg}
      dim_opacity 0.5

      selection_foreground none
      selection_background ${selection}

      color0  ${black}
      color8  ${bright_black}
      color1  ${red}
      color9  ${bright_red}
      color2  ${green}
      color10 ${bright_green}
      color3  ${yellow}
      color11 ${bright_yellow}
      color4  ${blue}
      color12 ${bright_blue}
      color5  ${magenta}
      color13 ${bright_magenta}
      color6  ${cyan}
      color14 ${bright_cyan}
      color7  ${white}
      color15 ${bright_white}
    '';
  };
}

