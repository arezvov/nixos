{ config, pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "600x15-5+40";
        shrink = "no";
        indicate_hidden = "yes";
        transparency = 0;
        notification_height = 0;
        separator_height = 3;
        padding = 8;
        horizontal_padding = 8;
        frame_width = 3;
        frame_color = "#90EE90";
        separator_color = "frame";
        sort = "yes";
        idle_threshold = 120;
        font = "Monospace 10";
        line_height = 0;
        markup = "full";
        format = "%s\n%b";
        alignment = "left";
        show_age_threshold = -1;
        word_wrap = "yes";
        ellipsize = "end";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = true;
        show_indicators = "yes";
        icon_position = "off";
        max_icon_size = 32;
        sticky_history = "yes";
        history_length = 100;
        dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst:";
        browser = "${pkgs.firefox}/bin/firefox -new-tab";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        startup_notification = false;
        force_xinerama = false;
      };
      "urgency_low" = {
        background = "#ffffff";
        foreground = "#888888";
        timeout = 5;
      };
      "urgency_normal" = {
        background = "#ffffff";
        foreground = "#000000";
        timeout = 10;
      };
      "urgency_critical" = {
        background = "#900000";
        foreground = "#ffffff";
        frame_color = "#ff0000";
        timeout = 0;
      };
    };
  };
}
