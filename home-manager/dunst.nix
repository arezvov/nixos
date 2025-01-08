{ config, pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Display
        follow = "mouse";
        width = "350";
        height = "(0, 300)";
        origin = "top-right";
        offset = "(35, 35)";
        indicate_hidden = "yes";
        notification_limit = "5";
        gap_size = "12";
        padding = "12";
        horizontal_padding = "20";
        frame_width = "1";
        sort = "no";

        # Progress bar
        progress_bar_frame_width = "0";
        progress_bar_corner_radius = "3";

        # Colors
        foreground = "#cdd1dc";
        frame_color = "#2d303c";
        highlight = "#2274d5, #82aad9";

        # Text
        font = "Noto Sans CJK JP 10";
        markup = "full";
        format = "<small>%a</small>\n<big><b>%s</b></big>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = "-1";
        hide_duplicate_count = "false";

        # Icon
        icon_position = "left";
        min_icon_size = "54";
        max_icon_size = "80";
        icon_path = "/usr/share/icons/Arc/status/96:/usr/share/icons/Arc/status/symbolic";
        icon_corner_radius = "4";

        # Misc/Advanced
        dmenu = "wofi --show drun --prompt 'Open with'";
        corner_radius = "10";

        # Mouse
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };
      "urgency_low" = {
        background = "#383c4af0";
        timeout = 5;
      };
      "urgency_normal" = {
        background = "#383c4af0";
        timeout = 10;
      };
      "urgency_critical" = {
        background = "#9b4d4bf0";
        frame_color = "#ab6d6b";
        highlight = "#e31e1b, #e37371";
        timeout = 0;
      };
    };
  };
}
