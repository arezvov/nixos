{ config, pkgs, pkgs-master, ... }:

let
  # Snapshot: DP-4 has browser, code, terminal and work; DP-2 has video.
  restore-session = pkgs.writeShellScriptBin "restore-desktop-session" ''
    set -euo pipefail
    export PATH=${pkgs.lib.makeBinPath [ pkgs.i3 pkgs.jq pkgs.coreutils ]}:"$PATH"

    has_window() {
      i3-msg -t get_tree | jq -e --arg class "$1" \
        'any(.. | objects; .window_properties.class? == $class)' >/dev/null
    }

    # Run only on a fresh i3 login, not on config reload or i3 restart.
    i3-msg 'workspace --no-auto-back-and-forth "10:Video"; workspace --no-auto-back-and-forth "2:Code"; layout tabbed' >/dev/null
    if ! has_window code; then
      ${pkgs-master.vscode-fhs}/bin/code ${pkgs.lib.escapeShellArg "${config.home.homeDirectory}/nixos"} &
    fi
    if ! has_window Alacritty; then
      ${config.programs.alacritty.package}/bin/alacritty \
        --working-directory ${pkgs.lib.escapeShellArg "${config.home.homeDirectory}/nixos"} &
    fi
    if ! has_window TelegramDesktop; then
      ${pkgs-master.telegram-desktop}/bin/Telegram &
    fi
    if ! has_window Google-chrome; then
      ${pkgs-master.google-chrome}/bin/google-chrome-stable --restore-last-session &
    fi

    # Chrome windows share WM_CLASS. Identify the saved video window once its
    # restored tab has loaded; don't move windows on later tab/title changes.
    video_restored=false
    focus_restored=false
    for attempt in $(seq 1 60); do
      video_id=$(i3-msg -t get_tree | jq -r '
        first(.. | objects | select(.window_properties.class? == "Google-chrome")
          | select(.window_properties.title? // "" | contains("YouTube")) | .id) // empty')
      if [ "$video_restored" = false ] && [ -n "$video_id" ]; then
        i3-msg "[con_id=$video_id] move container to workspace \"10:Video\"" >/dev/null
        video_restored=true
      fi
      if [ "$focus_restored" = false ] && has_window code && has_window Alacritty \
        && has_window Google-chrome && has_window TelegramDesktop; then
        i3-msg 'workspace --no-auto-back-and-forth "2:Code"; [class="^code$"] focus' >/dev/null
        focus_restored=true
      fi
      if [ "$video_restored" = true ] && [ "$focus_restored" = true ]; then
        break
      fi
      sleep 1
    done
  '';

  toggle-bluetooth = pkgs.writeShellScriptBin "toggle-bluetooth" ''
    set -euo pipefail

    tree=$(${pkgs.i3}/bin/i3-msg -t get_tree)
    if ${pkgs.jq}/bin/jq -e 'any(.. | objects;
      (.window_properties.class? // "" | ascii_downcase) == "blueman-manager")' \
      <<< "$tree" >/dev/null; then
      ${pkgs.i3}/bin/i3-msg '[class="(?i)^blueman-manager$"] kill'
    else
      exec ${pkgs.blueman}/bin/blueman-manager
    fi
  '';

  pass-rofi = pkgs.pass.override {
    dmenu = pkgs.writeShellScriptBin "dmenu" ''
      exec ${config.programs.rofi.package}/bin/rofi -dmenu "$@"
    '';
  };

  translate-notify = pkgs.writeShellScriptBin "translate-notify" ''
        if [[ $1 = -h || $1 = --help ]]; then
          echo "Usage: translate-notify from_lang to_lang text"
          echo "If text is omitted, xsel buffer will be used"
          echo "If languages are omitted, en-to-ru will be used"
          exit
        fi

        T_FROM="''${1:-en}"
        T_TO="''${2:-ru}"
        SELECTED_TEXT="''${3:-$(${pkgs.xsel}/bin/xsel -o)}"

        echo "$SELECTED_TEXT"

        GT_RESPONSE=$(${pkgs.wget}/bin/wget -U "Mozilla/5.0" -qO - \
          "http://translate.googleapis.com/translate_a/single?client=gtx&sl=$T_FROM&tl=$T_TO&dt=t&q=$SELECTED_TEXT")
        RESULT=$(${pkgs.python3}/bin/python3 -c "\
    import re;
    for s in re.compile('\[\".*?\",').findall('''$GT_RESPONSE'''):\
        print(s[2:-2])")
        WORDS=$(echo "$RESULT" | ${pkgs.coreutils}/bin/wc -w)
        TIMER=$((1500 + 500 * WORDS))
        echo "$RESULT"
        ${pkgs.libnotify}/bin/notify-send -i chromium -t "$TIMER" -u low "G: $RESULT"

        YT_API_KEY_FILE="''${XDG_CONFIG_HOME:-$HOME/.config}/translate-notify/yandex-api-key"
        if [[ -r "$YT_API_KEY_FILE" ]]; then
          YT_API_KEY=$(<"$YT_API_KEY_FILE")
          YT_RESPONSE=$(${pkgs.wget}/bin/wget -U "Mozilla/5.0" -qO - --no-check-certificate \
            "https://translate.yandex.net/api/v1.5/tr.json/translate?key=$YT_API_KEY&text=$SELECTED_TEXT&lang=$T_TO")
          RESULT=$(${pkgs.python3}/bin/python3 -c "print(('''$YT_RESPONSE''').split('\"')[-2])")
          ${pkgs.libnotify}/bin/notify-send -i accessories-dictionary -t "$TIMER" -u low "Y: $RESULT"
        fi
  '';

  open-tg = pkgs.writeShellScriptBin "OpenTG.sh" ''
    window_id=$(${pkgs.i3}/bin/i3-msg -t get_tree \
      | ${pkgs.jq}/bin/jq '.nodes[] | .. | select(.window_properties?.class? == "TelegramDesktop") | .id')
    echo "window_id: $window_id"

    if [ -z "$(${pkgs.procps}/bin/pidof Telegram)" ]; then
      ${pkgs.telegram-desktop}/bin/Telegram &
    else
      window_output=$(${pkgs.i3}/bin/i3-msg -t get_tree \
        | ${pkgs.jq}/bin/jq -r '.nodes[] | .. | select(.window_properties?.class? == "TelegramDesktop") | .output')

      if [ "$window_output" != "__i3" ]; then
        ${pkgs.i3}/bin/i3-msg "[con_id=$window_id] move scratchpad"
      else
        ${pkgs.i3}/bin/i3-msg "[con_id=$window_id] scratchpad show"
      fi
    fi
  '';
in
{
  home.packages =
    (with pkgs; [
      feh
      i3lock-fancy-rapid
      xbacklight
      xsel
    ])
    ++ [
      pass-rofi
      translate-notify
      open-tg
    ];

  services = {
    picom = {
      enable = true;
      vSync = true;
      fade = true;
      shadow = true;
      backend = "glx";
      # fadeSteps = [ 0.01 0.15 ];
      fadeDelta = 5;
      # package = pkgs.picom-pijulius;

      settings = {
        frame-opacity-for-same-colors = true;
        frame-opacity-for-same-colors-constraint = 0.5;
        frame-opacity-for-same-colors-multiplier = 5;
        frame-opacity = 0.7;
      };
    };
  };

  programs.rofi = {
    enable = true;
    theme = "Arc-Dark";
  };

  xsession.enable = true;

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      floating.criteria = [ { class = "(?i)^blueman-manager$"; } ];
      window.commands = [
        {
          criteria.class = "^code$";
          command = "border none";
        }
        {
          criteria.class = "^Chatzone$";
          command = "border none";
        }
        {
          criteria.class = "^TelegramDesktop$";
          command = "floating enable, resize set 1910 px 1620 px, move position 960 px 251 px, move scratchpad";
        }
        {
          criteria.class = "(?i)^blueman-manager$";
          command = "floating enable, resize set 600 px 450 px, move position center";
        }
      ];

      assigns = {
        "1:Browser" = [ { class = "^Google-chrome$"; window_role = "^browser$"; } ];
        "2:Code" = [ { class = "^code$"; } ];
        "3:Terminal" = [ { class = "^Alacritty$"; } ];
        "8:Work" = [ { class = "^Chatzone$"; } ];
      };

      workspaceOutputAssign = [
        {
          workspace = "1:Browser";
          output = "DP-4"; # Hisense 27G7K-PRO
        }
        { workspace = "2:Code"; output = "DP-4"; }
        { workspace = "3:Terminal"; output = "DP-4"; }
        { workspace = "8:Work"; output = "DP-4"; }
        { workspace = "10:Video"; output = "DP-2"; }
      ];

      fonts = {
        names = [ "pango" ];
        style = "monospace";
        size = 12.0;
      };
      keybindings =
        let
          mod = config.xsession.windowManager.i3.config.modifier;
        in
        {
          "XF86AudioRaiseVolume" =
            "exec --no-startup-id ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" =
            "exec --no-startup-id ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "Shift+XF86AudioRaiseVolume" =
            "exec --no-startup-id ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+";
          "Shift+XF86AudioLowerVolume" =
            "exec --no-startup-id ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
          "XF86AudioMute" =
            "exec --no-startup-id ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute" =
            "exec --no-startup-id ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "${mod}+Return" = "exec alacritty";
          "${mod}+b" = "exec --no-startup-id ${toggle-bluetooth}/bin/toggle-bluetooth";
          "Mod1+e" = "exec --no-startup-id ${translate-notify}/bin/translate-notify";
          "${mod}+t" = "exec --no-startup-id ${open-tg}/bin/OpenTG.sh";
          #"Mod1+w --release" = "exec /home/alex/scripts/cb 2&>1 /tmp/cb.log";
          "control+Mod1+l" = "exec --no-startup-id ${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 15 20";
          "${mod}+q" = "exec --no-startup-id clipcat-menu";
          #"${mod}+q" = "exec CM_HISTLENGTH=30 clipmenu -i -fn Terminus:size=10 -nb '#002b36' -nf '#839496' -sb '#073642' -sf '#93a1a1'";
          # "control+Mod1+l" = "exec ${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 3 10";
          #"${mod}+q" =
          #  "exec CM_HISTLENGTH=30 clipmenu -i -fn Terminus:size=10 -nb '#002b36' -nf '#839496' -sb '#073642' -sf '#93a1a1'";
          "${mod}+Shift+q" = "kill";
          "${mod}+d" = "exec --no-startup-id ${config.programs.rofi.package}/bin/rofi -show drun";
          "${mod}+z" = "exec --no-startup-id ${pass-rofi}/bin/passmenu -i -l 20";

          "${mod}+j" = "focus left";
          "${mod}+k" = "focus down";
          "${mod}+l" = "focus up";
          "${mod}+semicolon" = "focus right";

          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          "${mod}+Shift+j" = "move left";
          "${mod}+Shift+k" = "move down";
          "${mod}+Shift+l" = "move up";
          "${mod}+Shift+semicolon" = "move right";

          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+h" = "split h";
          "${mod}+v" = "split v";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";
          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";
          "${mod}+a" = "focus parent";

          "${mod}+1" = "workspace $ws1";
          "${mod}+2" = "workspace $ws2";
          "${mod}+3" = "workspace $ws3";
          "${mod}+4" = "workspace $ws4";
          "${mod}+5" = "workspace $ws5";
          "${mod}+6" = "workspace $ws6";
          "${mod}+7" = "workspace $ws7";
          "${mod}+8" = "workspace $ws8";
          "${mod}+9" = "workspace $ws9";
          "${mod}+0" = "workspace $ws10";

          "${mod}+Shift+1" = "move container to workspace $ws1";
          "${mod}+Shift+2" = "move container to workspace $ws2";
          "${mod}+Shift+3" = "move container to workspace $ws3";
          "${mod}+Shift+4" = "move container to workspace $ws4";
          "${mod}+Shift+5" = "move container to workspace $ws5";
          "${mod}+Shift+6" = "move container to workspace $ws6";
          "${mod}+Shift+7" = "move container to workspace $ws7";
          "${mod}+Shift+8" = "move container to workspace $ws8";
          "${mod}+Shift+9" = "move container to workspace $ws9";
          "${mod}+Shift+0" = "move container to workspace $ws10";

          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+e" =
            ''exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"'';

          "${mod}+r" = ''mode "resize"'';
        };

      keycodebindings = {
        "233" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
        "232" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        "172" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
        "174" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl stop";
        "173" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl previous";
        "171" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl next";
        "--release 107" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";
      };

      modes = {
        resize = {
          "j" = "resize shrink width 10 px or 10 ppt";
          "k" = "resize grow height 10 px or 10 ppt";
          "l" = "resize shrink height 10 px or 10 ppt";
          "semicolon" = "resize grow width 10 px or 10 ppt";

          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";

          "Return" = ''mode "default"'';
          "Escape" = ''mode "default"'';
          "Mod4+r" = ''mode "default"'';
        };
      };
      modifier = "Mod4";
      bars = [ ];
      terminal = "alacritty";
      workspaceAutoBackAndForth = true;
      startup = [
        {
          command = "${restore-session}/bin/restore-desktop-session";
          notification = false;
        }
        {
          # Set the cursor used over empty workspace areas.
          command = "${pkgs.xsetroot}/bin/xsetroot -cursor_name left_ptr";
          always = true;
          notification = false;
        }
        {
          # The Home Manager service may start before i3 has created its IPC
          # socket. Restart it from i3 so the workspace module can connect.
          command = "systemctl --user restart polybar.service";
          always = true;
          notification = false;
        }
        {
          command = ''setxkbmap "us,ru" ",winkeys" "grp:alt_shift_toggle"'';
          always = true;
          notification = false;
        }
      ];
    };
    extraConfig = ''
      set $ws1 "1:Browser"
      set $ws2 "2:Code"
      set $ws3 "3:Terminal"
      set $ws4 "4"
      set $ws5 "5"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8:Work"
      set $ws9 "9"
      set $ws10 "10:Video"
    '';
  };
}
