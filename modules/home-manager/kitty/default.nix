

{ pkgs, lib, config, ... }:

with lib;
let 
  cfg = config.modules.kitty;


in {
    options.modules.kitty= { enable = mkEnableOption "kitty"; };
    config = mkIf cfg.enable {
	programs.kitty = with config.stylix.base16Scheme; {
	  enable = true;
	  shellIntegration.enableZshIntegration = true;

          keybindings = {
            "ctrl+shift+v" = "paste_from_clipboard";
            "ctrl+shift+s" = "paste_from_selection";
            "ctrl+shift+c" = "copy_to_clipboard";
            "shift+insert" = "paste_from_selection";
            
            "ctrl+shift+up" = "scroll_line_up";
            "ctrl+shift+down" = "scroll_line_down";
            "ctrl+shift+]" = "scroll_line_up";
            "ctrl+shift+[" = "scroll_line_down";
            "ctrl+shift+page_up" = "scroll_page_up";
            "ctrl+shift+page_down" = "scroll_page_down";
            "ctrl+shift+home" = "scroll_home";
            "ctrl+shift+end" = "scroll_end";
            "ctrl+shift+n" = "show_scrollback";
            
            "ctrl+shift+'" = "new_window_with_cwd";
            "ctrl+shift+/" = "new_window";
            "ctrl+shift+q" = "close_window";
            "ctrl+shift+j" = "next_window";
            "ctrl+shift+k" = "previous_window";
            "ctrl+shift+f" = "move_window_forward";
            "ctrl+shift+b" = "move_window_backward";
            "ctrl+shift+`" = "nth_window -1";
            "ctrl+shift+1" = "first_window";
            "ctrl+shift+2" = "second_window";
            "ctrl+shift+3" = "third_window";
            "ctrl+shift+4" = "fourth_window";
            "ctrl+shift+5" = "fifth_window";
            "ctrl+shift+6" = "sixth_window";
            "ctrl+shift+7" = "seventh_window";
            "ctrl+shift+8" = "eighth_window";
            "ctrl+shift+9" = "ninth_window";
            "ctrl+shift+0" = "tenth_window";
            
            "ctrl+shift+l" = "next_tab";
            "ctrl+shift+h" = "previous_tab";
            "ctrl+shift+t" = "new_tab";
            "ctrl+shift+tab" = "next_layout";
            "ctrl+shift+right" = "move_tab_forward";
            "ctrl+shift+left" = "move_tab_backward";
            "ctrl+shift+alt+t" = "set_tab_title";
            
            "ctrl+shift+equal" = "increase_font_size";
            "ctrl+shift+minus" = "decrease_font_size";
            "ctrl+shift+backspace" = "restore_font_size";
	  };

    # NOTE: This is how to override stylix options
    # settings."font_size" = lib.mkForce 64;


	  # settings = lib.mkForce {
	  #   font_family = "Iosevka Comfy";
	  #   italic_font = "auto";
	  #   bold_font = "auto";
	  #   font_size = 16;
	  #
	  #             adjust_line_height = "0";
	  #             adjust_column_width = "0";
	  #             box_drawing_scale = "0.001, 1, 1.5, 2";
	  #
	  #             # Cursor
	  #             cursor_shape = "underline";
	  #             cursor_blink_interval = "0";
	  #             cursor_stop_blinking_after = "15.0";
	  #
	  #             # Scrollback
	  #             scrollback_lines = "10000";
	  #             scrollback_pager = "/usr/bin/less";
	  #             wheel_scroll_multiplier = "5.0";
	  #
	  #             # URLs
	  #             url_style = "double";
	  #             open_url_modifiers = "ctrl+shift";
	  #             open_url_with = "firefox";
	  #             copy_on_select = "yes";
	  #
	  #             # Selection
	  #             rectangle_select_modifiers = "ctrl+shift";
	  #             select_by_word_characters = ":@-./_~?&=%+#";
	  #
	  #             # Mouse
	  #             click_interval = "0.5";
	  #             mouse_hide_wait = "0";
	  #             focus_follows_mouse = "no";
	  #
	  #             # Performance
	  #             repaint_delay = "20";
	  #             input_delay = "2";
	  #             sync_to_monitor = "no";
	  #
	  #             # Bell
	  #             visual_bell_duration = "0.0";
	  #             enable_audio_bell = "no";
	  #
	  #             # Window
	  #             remember_window_size = "no";
	  #             initial_window_width = "700";
	  #             initial_window_height = "400";
	  #             window_border_width = "0";
	  #             window_margin_width = "0";
	  #             window_padding_width = "0";
	  #             inactive_text_alpha = "1.0";
	  #             background_opacity = "1.0";
	  #
	  #             # Layouts
	  #             enabled_layouts = "*";
	  #
	  #             # Tabs
	  #             tab_bar_edge = "bottom";
	  #             tab_separator = " ┇";
	  #             active_tab_font_style = "bold";
	  #             inactive_tab_font_style = "normal";
	  #
	  #             # Shell
	  #             shell = ".";
	  #             close_on_child_death = "no";
	  #             allow_remote_control = "yes";
	  #             term = "xterm-kitty";
	  #
	  #
	  #
	  #   # Base16 Dracula - kitty color config
	  #             # Scheme by Mike Barkmin (http://github.com/mikebarkmin) based on Dracula Theme (http://github.com/dracula)
	  #             background = "#${base00}";
	  #             foreground = "#${base05}";
	  #             selection_background = "#${base05}";
	  #             selection_foreground = "#${base00}";
	  #             url_color = "#${base04}";
	  #             cursor = "#${base05}";
	  #             active_border_color = "#${base03}";
	  #             inactive_border_color = "#${base01}";
	  #             active_tab_background = "#${base00}";
	  #             active_tab_foreground = "#${base05}";
	  #             inactive_tab_background = "#${base01}";
	  #             inactive_tab_foreground = "#${base04}";
	  #             tab_bar_background = "#${base01}";
	  #           
	  #             # normal
	  #             color0 = "#${base00}";
	  #             color1 = "#${base08}";
	  #             color2 = "#${base0B}";
	  #             color3 = "#${base0A}";
	  #             color4 = "#${base04}";
	  #             color5 = "#${base09}";
	  #             color6 = "#${base0C}";
	  #             color7 = "#${base05}";
	  #           
	  #             # bright
	  #             color8 = "#${base03}";
	  #             color9 = "#${base08}";
	  #             color10 = "#${base0B}";
	  #             color11 = "#${base0A}";
	  #             color12 = "#${base04}";
	  #             color13 = "#${base09}";
	  #             color14 = "#${base0C}";
	  #             color15 = "#${base07}";
	  #           
	  #             # extended base16 colors
	  #             color16 = "#${base09}";
	  #             color17 = "#${base0A}";
	  #             color18 = "#${base01}";
	  #             color19 = "#${base02}";
	  #             color20 = "#${base04}";
	  #             color21 = "#${base06}";
	  # };
	};
  programs.zsh = {
    initExtra = ''
      export TERM="xterm-kitty"
      '';
  };
    };
}
