{ pkgs, ... }:

{
  services.polybar = { 
    enable = true;
    script = "polybar bar &";
    package = pkgs.polybarFull;
    config = {
      "bar/bar" = {
        width = "100%";
        height = 27;
        offset-x = "0%";
        module-margin = 0;
        radius = "1.0";
        fixed-center = false;
        bottom = true;
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        line-size = 3;
        line-color = "#f00";
        border-size = 0;
        border-color = "#00000000";
        padding-left = 0;
        padding-right = 0;
        module-margin-left = 1;
        module-margin-right = 0;
        font-0 = "JetBrains Mono:pixelsize=10;1";
        font-1 = "unifont:fontformat=truetype:size=8:antialias=false;0";
        font-2 = "siji:pixelsize=16;1";
        modules-left = "i3";
        modules-center = "";
        modules-right = "pulseaudio backlight-acpi filesystem xkeyboard memory cpu battery wlan date";
        tray-position = "right";
        tray-padding = 0;
        tray-scale = "1.0";
        tray-maxsize = 23;
        tray-offset-x = 0;
        tray-offset-y = 0;
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        # monitor = "DP-2";
      };

      "colors" = {
        background = "#222";
        background-alt = "#444";
        foreground = "#dfdfdf";
        foreground-alt = "#555";
        primary = "#ffb52a";
        secondary = "#e60053";
        alert = "#bd2c40";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";

        format-volume = "<label-volume> <bar-volume>";
        label-volume = "VOL %percentage%%";
        label-volume-foreground = "\${root.foreground}";

        label-muted = "🔇 muted";
        label-muted-foreground = "#666";

        bar-volume-width = 10;
        bar-volume-foreground-0 = "#55aa55";
        bar-volume-foreground-1 = "#55aa55";
        bar-volume-foreground-2 = "#55aa55";
        bar-volume-foreground-3 = "#55aa55";
        bar-volume-foreground-4 = "#55aa55";
        bar-volume-foreground-5 = "#f5a70a";
        bar-volume-foreground-6 = "#ff5555";
        bar-volume-gradient = false;
        bar-volume-indicator = "|";
        bar-volume-indicator-font = 2;
        bar-volume-fill = "─";
        bar-volume-fill-font = 2;
        bar-volume-empty = "─";
        bar-volume-empty-font = 2;
        bar-volume-empty-foreground = "\${colors.foreground-alt}";
      };
      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        blacklist-0 = "num lock";

        format-prefix = " ";
        format-prefix-foreground = "\${colors.foreground-alt}";
        format-prefix-underline = "\${colors.secondary}";

        label-layout = "%layout%";
        label-layout-underline = "\${colors.secondary}";

        label-indicator-padding = 2;
        label-indicator-margin = 10;
        label-indicator-background = "\${colors.secondary}";
        label-indicator-underline = "\${colors.secondary}";
      };
      "module/filesystem" = {

        type = "internal/fs";
        interval = 25;
        mount-0 = "/";
        label-mounted = "%{F#0a81f5}%mountpoint%%{F-}: %used%/%total%";
        label-unmounted = "%mountpoint% not mounted";
        label-unmounted-foreground = "\${colors.foreground-alt}";
      };
      "module/i3" = {
        type = "internal/i3";
        format = "<label-state> <label-mode>";
        index-sort = true;
        wrapping-scroll = false;
        label-mode-padding = 2;
        label-mode-foreground = "#000";
        label-mode-background = "\${colors.primary}";
        label-focused = "%index%";
        label-focused-background = "\${colors.background-alt}";
        label-focused-underline= "\${colors.primary}";
        label-focused-padding = 2;
        label-unfocused = "%index%";
        label-unfocused-padding = 2;
        label-visible = "%index%";
        label-visible-background = "\${self.label-focused-background}";
        label-visible-underline = "\${self.label-focused-underline}";
        label-visible-padding = "\${self.label-focused-padding}";
        label-urgent = "%index%";
        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = 2;
        label-separator-padding = 0;
      };
      "module/xbacklight" = {
        type = "internal/xbacklight";

        format = "<label> <bar>";
        label = "BL";

        bar-width = 20;
        bar-indicator = "|";
        bar-indicator-foreground = "#fff";
        bar-indicator-font = 2;
        bar-fill = "─";
        bar-fill-font = 2;
        bar-fill-foreground = "#9f78e1";
        bar-empty = "─";
        bar-empty-font = 2;
        bar-empty-foreground = "\${colors.foreground-alt}";
      };
      "module/backlight-acpi" = {
        "inherit" = "module/xbacklight";
        type = "internal/backlight";
        enable-scroll = true;
        card = "amdgpu_bl0";
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 1;
        format-prefix = " ";
        format-prefix-foreground = "\${colors.foreground-alt}";
        format-underline = "#f90000";
        label = "%percentage:2%%";
      };
      "module/memory" = {
        type = "internal/memory";
        interval = 1;
        format-prefix = " ";
        format-prefix-foreground = "\${colors.foreground-alt}";
        format-underline = "#4bffdc";
        label = "%percentage_used%%";
      };
      "module/wlan" = {
        type = "internal/network";
        interface = "wlan0";
        interval = "3.0";
        format-connected = "<ramp-signal> <label-connected>";
        format-connected-underline = "#9f78e1";
        label-connected = "%essid% [%local_ip%]";
        format-disconnected = "";
        ramp-signal-0 = "";
        ramp-signal-1 = "";
        ramp-signal-2 = "";
        ramp-signal-3 = "";
        ramp-signal-4 = "";
        ramp-signal-foreground = "\${colors.foreground-alt}";
      };
      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%d/%m/%Y";
        time = "%H:%M:%S";
        format-prefix-foreground = "\${colors.foreground-alt}";
        format-underline = "#0a6cf5";
        label = "%time% %date%";
      };
      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "ADP0";
        full-at = 98;
        format-charging = "<animation-charging> <label-charging>";
        format-charging-underline = "#ffb52a";
        format-discharging = "<animation-discharging> <label-discharging>";
        format-discharging-underline = "\${self.format-charging-underline}";
        format-full-prefix = " ";
        format-full-prefix-foreground = "\${colors.foreground-alt}";
        format-full-underline = "\${self.format-charging-underline}";
        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-foreground = "\${colors.foreground-alt}";
        label-charging = "%percentage%% (%time%)";
        label-discharging = "%percentage%% (%time%)";
        time-format = "%H:%M";
        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-foreground = "\${colors.foreground-alt}";
        animation-charging-framerate = 750;
        animation-discharging-0 = "";
        animation-discharging-1 = "";
        animation-discharging-2 = "";
        animation-discharging-foreground = "\${colors.foreground-alt}";
        animation-discharging-framerate = 750;
      };
    };
  };
}
