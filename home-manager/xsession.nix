{ config, pkgs, ... }:

let
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
      dmenu
      feh
      i3lock-fancy-rapid
      pass
      xbacklight
      xsel
    ])
    ++ [
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

  xsession.enable = true;

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      fonts = {
        names = [ "pango" ];
        style = "monospace";
        size = 12.0;
      };
      keybindings = let mod = config.xsession.windowManager.i3.config.modifier;
      in {
        "${mod}+Return" = "exec alacritty";
        "Mod1+e" = "exec ${translate-notify}/bin/translate-notify";
        "${mod}+t" = "exec --no-startup-id ${open-tg}/bin/OpenTG.sh";
        #"Mod1+w --release" = "exec /home/alex/scripts/cb 2&>1 /tmp/cb.log";
        "control+Mod1+l" = "exec ${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 15 20";
        "${mod}+q" = "exec clipcat-menu";
        #"${mod}+q" = "exec CM_HISTLENGTH=30 clipmenu -i -fn Terminus:size=10 -nb '#002b36' -nf '#839496' -sb '#073642' -sf '#93a1a1'";
        # "control+Mod1+l" = "exec ${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 3 10";
        #"${mod}+q" =
        #  "exec CM_HISTLENGTH=30 clipmenu -i -fn Terminus:size=10 -nb '#002b36' -nf '#839496' -sb '#073642' -sf '#93a1a1'";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec dmenu_run";
        "${mod}+z" = "exec passmenu -l 50";

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
        "${mod}+Shift+e" = ''
          exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"'';

        "${mod}+r" = ''mode "resize"'';
      };

      keycodebindings = {
        "233" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
        "232" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        "172" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "174" = "exec ${pkgs.playerctl}/bin/playerctl stop";
        "173" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        "171" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "107" = "exec ${pkgs.flameshot}/bin/flameshot gui";
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
          # The Home Manager service may start before i3 has created its IPC
          # socket. Restart it from i3 so the workspace module can connect.
          command = "systemctl --user restart polybar.service";
          always = true;
          notification = false;
        }
        {
          command = ''setxkbmap "us,ru" ",winkeys" "grp:alt_shift_toggle"'';
          always = true;
        }
      ];
    };
    extraConfig = ''
      set $ws1 "1"
      set $ws2 "2"
      set $ws3 "3:tg+slack"
      set $ws4 "4"
      set $ws5 "5"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8"
      set $ws9 "9"
      set $ws10 "10"
    '';
  };
}
