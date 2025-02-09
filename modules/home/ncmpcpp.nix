#TODO: Music Site pass is clear stored
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.ncmpcpp;
in {
  options.my.ncmpcpp = {enable = mkEnableOption "ncmpcpp";};
  config = mkIf cfg.enable {


    services.mpdris2 = {
      enable = true;
      multimediaKeys = true;
      notifications = true;
    };



    services.mpris-proxy.enable = true;
    services.mpd.musicDirectory = "${config.home.homeDirectory}/documents/music";
    services.mopidy = let
      mopidyPackagesOverride = pkgs.mopidyPackages.overrideScope (prev: final: {
        extraPkgs = pkgs: [pkgs.yt-dlp pkgs.gst_all_1.gst-plugins-base];
      });
    in {
      enable = true;
      extensionPackages = with mopidyPackagesOverride; [
        mopidy-notify
        mopidy-mpd
        mopidy-jellyfin
        mopidy-local
        mopidy-mpris
      ];
      settings = {
        mpd = {
          enabled = true;
          hostname = "localhost";
          port = 6600;
          connection_timeout = 300;
        };
        audio = {
          mixer = "software";
          output = "tee name=t ! queue ! autoaudiosink t. ! queue ! audio/x-raw,rate=44100,channels=2,format=S16LE ! udpsink host=localhost port=5555";
        };
        notify = {
          enabled = true;
        };
        jellyfin = {
          hostname = "mus.loganreed.org";
          # token = "eb6e5376fa9a4e4cbdafbaa6fc39c0bc";
          username = "occam";
          password = "Logsdad01cheese";
          libraries = "Music";
          albumartistsort = false;
        };
        local = {
          enabled = true;
          # TODO: Make this an option so both systems work
          # media_dir = "/documents/music";
          media_dir = "${config.home.homeDirectory}/documents/music";
        };
        softwaremixer = {
          enabled = true;
        };
        mpris = {
          enabled = true;
          bus_type = "session";
        };
      };
    };
    #       settings = ''
    # [mpd]
    # enabled = true
    # # Useful if you want to control this instance from a remote MPD client
    # hostname = localhost
    # port = 6600
    # # This will help avoid timeout errors for  artists or folders with large amounts of files
    # connection_timeout = 300
    #
    # # Used in the event you want to control this system from a web browser
    # # [http]
    # #hostname = 127.0.0.1
    # #port = 6680
    #
    # [audio]
    # mixer = software
    # output = tee name=t ! queue ! autoaudiosink t. ! queue ! audio/x-raw,rate=44100,channels=2,format=S16LE ! udpsink host=localhost port=5555
    #
    #
    # [jellyfin]
    # hostname = mus.loganreed.org
    # username = occam
    # password = Logsdad01cheese
    # libraries = Music
    # albumartistsort = False
    # album_format = {Name}
    #
    # [local]
    # enabled = true
    # media_dir = /documents/music
    #
    # [softwaremixer]
    # enabled = true
    #
    #       '';
    # services.mpd = {
    #   enable = true;
    #   musicDirectory = "${config.home.homeDirectory}/documents/music";
    #   extraConfig = ''
    #         audio_output {
    #           type "pipewire"
    #           name "My Pipewire output"
    #         }
    #
    #         audio_output {
    #         type                    "fifo"
    #         name                    "Visualizer feed"
    #         path                    "/tmp/mpd.fifo"
    #         format                  "44100:16:2"
    #     }
    #   '';
    # };

    # services.mopidy.enable = true;
    # services.mopidy.extensionPackages = with pkgs;
    # [
    #   mopidy-jellyfin
    #     mopidy-local
    #     mopidy-mpd
    #     mopidy-notify
    # ];
    # services.mopidy.settings = {
    #   file = {
    #     media-dirs = [ "/home/occam/documents|music|Music" ];
    #     follow_symlinks = true;
    #     excluded_file_extensions = [
    #       ".html"
    #         ".zip"
    #         ".jpg"
    #         ".jpeg"
    #         ".png"
    #     ];
    #   };
    #   audio = {
    #     mixer = "software";
    #     output ="autoaudiosink" ;
    #   };
    #   core = {
    #     cache_dir = "$XDG_CACHE_DIR/mopidy";
    #     restore_state = true;
    #   };
    #   jellyfin = {
    #     enabled = true;
    #     hostname = "mus.loganreed.org";
    #     username = "occam";
    #     password = "Logsdad01cheese";
    #
    #   };
    #   mpd = {
    #     enabled = true;
    #     port = 6600;
    #     zeroconf = "Mopidy server on $hostname";
    #     default_playlist_scheme = "m3u";
    #
    #   };
    #   podcast = {
    #     enabled = true;
    #   };
    #   local = {
    #     enabled = true;
    #     media_dir = "~/documents/music";
    #     excluded_file_extensions = ''
    #       .directory
    #       .html
    #       .jpeg
    #       .jpg
    #       .log
    #       .nfo
    #       .png
    #       .txt
    #       '';
    #   };
    #   softwaremixer = {
    #     enabled = true;
    #   };
    # };

    programs.ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override {visualizerSupport = true;};
      bindings = [
        {
          key = "l";
          command = "next_column";
        }
        {
          key = "h";
          command = "previous_column";
        }
        {
          key = "j";
          command = "scroll_down";
        }
        {
          key = "k";
          command = "scroll_up";
        }
        {
          key = "J";
          command = ["select_item" "scroll_down"];
        }
        {
          key = "K";
          command = ["select_item" "scroll_up"];
        }
        {
          key = "n";
          command = "next_found_item";
        }
        {
          key = "N";
          command = "previous_found_item";
        }
        {
          key = "g";
          command = "move_home";
        }
        {
          key = "G";
          command = "move_end";
        }
      ];
      mpdMusicDir = "${config.home.homeDirectory}/documents/music";
      settings = {
        user_interface = "alternative";
        alternative_header_first_line_format = "$(white)─┤ $b$(green)%a$(end)$/b ├─$(end)";
        alternative_header_second_line_format = "$(16)%t (%y)$(end)";
        alternative_ui_separator_color = "cyan";
        song_columns_list_format = "$L(9)[white]{l} (20)[green]{a} (30)[yellow]{b}$R(20)[cyan]{t}";
        # song_columns_list_format = 				"$L (10)[white]{n} $1│$7 (20)[green]{a} $1│$7 (20)[yellow]{b} $1│$7 (20)[red]{t} $1│$7 (20)[magenta]{l}";
        now_playing_prefix = "$b";
        centered_cursor = "no";
        cyclic_scrolling = "yes";
        mouse_list_scroll_whole_page = "no";

        mpd_host = "localhost";
        mpd_port = "6600";

        # Varias configuraciones:
        autocenter_mode = "yes";
        display_bitrate = "yes";
        header_visibility = "yes";
        statusbar_visibility = "yes";
        # progressbar_look = 						"░█ ";
        progressbar_look = "─╼ ";

        # Visualizador de música:
        visualizer_output_name = "Visualizer feed";
        visualizer_in_stereo = "yes";
        visualizer_data_source = "localhost:5555";
        # visualizer_sync_interval = "10";
        visualizer_fps = 60;
        visualizer_autoscale = "no";
        visualizer_type = "spectrum";
        visualizer_look = "●▋";
        visualizer_spectrum_smooth_look = "yes";
        visualizer_spectrum_gain = 10;
        # Color:
        color1 = "white";
        color2 = "red";
        discard_colors_if_item_is_selected = "yes";
        main_window_color = "white";
        header_window_color = "4";
        progressbar_color = "cyan";
        statusbar_color = "blue";
        # active_column_color = 					"white";
        volume_color = "4";
        window_border_color = "white";
        active_window_border = "4";
      };
    };
  };
}
# old
# settings = {
#   alternative_header_first_line_format = "$5{$b%t$/b}$9";
#   alternative_header_second_line_format = "$3by $7{$b%a$/b}$9 $3from $7{$b%b$/b}$9 $5{(%y)}";
#   song_list_format = "♫   $2%n$(end) $9 $3%a$(end) $(245)-$9 $(246)%t$9 $R{ $5%y$9}$(end)     $(246)%lq$(end)";
#   song_columns_list_format = "(3f)[red]{n} (3f)[246]{} (35)[white]{t} (18)[blue]{a} (30)[green]{b} (5f)[yellow]{d} (5f)[red]{y} (7f)[magenta]{l}";
#   song_status_format = "$b $8%A $8•$3• $3%t $3•$5• $5%b $5•$2• $2%y $2•$8• %g";
#   playlist_display_mode = "columns";
#   browser_display_mode = "columns";
#   search_engine_display_mode = "columns";
#   now_playing_prefix = "$b";
#   now_playing_suffix = "$/b";
#   browser_playlist_prefix = "$2 ♥ $5 ";
#   playlist_disable_highlight_delay = "1";
#   message_delay_time = "1";
#   progressbar_look = "━━━";
#   colors_enabled = "yes";
#   empty_tag_color = "red";
#   statusbar_color = "blue";
#   state_line_color = "black";
#   state_flags_color = "default";
#   main_window_color = "blue";
#   header_window_color = "white";
#   alternative_ui_separator_color = "black";
#   window_border_color = "green";
#   active_window_border = "red";
#   volume_color = "default";
#   progressbar_color = "black";
#   progressbar_elapsed_color = "blue";
#   statusbar_time_color = "blue";
#   player_state_color = "default";
#   display_bitrate = "yes";
#   autocenter_mode = "yes";
#   centered_cursor = "yes";
#   titles_visibility = "no";
#   enable_window_title = "yes";
#   statusbar_visibility = "yes";
#   empty_tag_marker = "";
#   mouse_support = "yes";
#   header_visibility = "no";
#   display_remaining_time = "no";
#   ask_before_clearing_playlists = "yes";
#   discard_colors_if_item_is_selected = "yes";
#   user_interface = "alternative";
#   default_find_mode = "wrapped";
#   lyrics_directory = "~/.lyrics";
#   follow_now_playing_lyrics = "yes";
#   store_lyrics_in_song_dir = "no";
#   ignore_leading_the = "yes";
#   lines_scrolled = "1";
#   mouse_list_scroll_whole_page = "no";
#   show_hidden_files_in_local_browser = "no";
#   startup_screen = "playlist";
#   connected_message_on_startup = "no";
#   playlist_separate_albums = "no";
#   allow_for_physical_item_deletion = "no";
#   visualizer_fps = 60;
#   visualizer_sync_interval = 60;
#   visualizer_in_stereo = "yes";
#   visualizer_data_source = "/tmp/mpd.fifo";
#   visualizer_type = "spectrum";
#   visualizer_look = "▉▋";
# };

