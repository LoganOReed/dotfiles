{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.beets;
in {
  options.modules.beets = {enable = mkEnableOption "beets";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi-bluetooth
    ];

    programs.beets = {
      enable = true;
      package = pkgs.beets.override {
        pluginOverrides = {
          lyrics.enable = true;
          info.enable = true;
          fetchart.enable = true;
          embedart.enable = true;
          edit.enable = true;
          mpdstats.enable = true;
          mpdupdate.enable = true;
          fromfilename.enable = true;
          lastimport.enable = true;
          replaygain.enable = true;
          playlist.enable = true;
          # discogs.enable = true;
          scrub.enable = true;
        };
      };
      settings = {
        "directory" = "~/documents/music";
        "library" = "~/documents/.music.db";
        "import" = {
          "write" = true;
          "move" = true;
          "copy" = false;
          "delete" = false;
          "autotag" = true;
          "timid" = false;
          "resume" = "ask";
          "incremental" = false;
          "quiet" = false;
          "quiet_fallback" = "skip";
          "default_action" = "apply";
        };
        #autotagger
        "match" = {
          "strong_rec_thresh" = 0.1;
          "medium_rec_thresh" = 0.25;
          "rec_gap_thresh" = 0.25;
          "max_rec" = {
            "missing_tracks" = "medium";
            "unmatched_tracks" = "medium";
          };
          "distance_weights" = {
            "source" = 2.0;
            "artist" = 3.0;
            "album" = 3.0;
            "media" = 1.0;
            "mediums" = 1.0;
            "year" = 1.0;
            "country" = 0.5;
            "label" = 0.5;
            "catalognum" = 0.5;
            "albumdisambig" = 0.5;
            "album_id" = 5.0;
            "tracks" = 2.0;
            "missing_tracks" = 0.9;
            "unmatched_tracks" = 0.6;
            "track_title" = 3.0;
            "track_artist" = 2.0;
            "track_index" = 1.0;
            "track_length" = 2.0;
            "track_id" = 5.0;
          };
          "ignored" = [];
          "track_length_grace" = 10;
          "track_length_max" = 30;
        };
        # files matching these patterns are deleted from source after import
        "clutter" = ["Thumbs.DB" ".DS_Store" "*.m3u" ".pls" "*.torrent"];
        "paths" = {
          "default" = "%asciify{$albumartist}/%asciify{$album}%aunique{}/$track %asciify{$title}";
          "singleton" = "Non-Album/%asciify{$artist}/%asciify{$title}";
          "comp" = "Compilations/%asciify{$album}%aunique{}/$track %asciify{$title}";
        };
        # Seems to make things fucky
        # "replace" = {
        #   "[\\/]" = "_";
        #   "^\." = "_";
        #   "[\x00-\x1f]" = "_";
        #   "[<>:\"\?\*\|]" = "_";
        #   "\.$" = "_";
        #   "\s+$" = "";
        # };
        "path_sep_replace" = "_";
        "art_filename" = "cover";
        "max_filename_length" = 0;

        "threaded" = true;
        "timeout" = 5.0;
        "verbose" = false;
        "plugins" = ["lyrics" "info" "fetchart" "embedart" "fromfilename" "lastimport" "replaygain" "playlist" "scrub" "mpdstats" "mpdupdate" "edit"];
        "playlist" = {
          "auto" = true;
          "relative_to" = "~/documents/music";
          "playlist_dir" = "~/.local/share/mpd/playlists";
        };
        "fetchart" = {
          "auto" = true;
          "maxwidth" = 300;
          "cautious" = true;
          "cover_names" = ["cover" "folder"];
        };
        "embedart" = {
          "auto" = true;
          "maxwidth" = 300;
        };
        "mpd" = {
          "host" = "localhost";
          "port" = 6600;
        };
        "mpdstats" = {
          "rating" = false;
          "rating_mix" = 0.75;
        };
      };
    };

    home.file.".zsh/completion/beet/beet.zsh-completion".source = ./beet.zsh-completion;
    programs.zsh = {
      initExtra = ''
        fpath=( "/home/occam/.zsh/completion/beet" "''${fpath[@]}" )
      '';
    };
  };
}
