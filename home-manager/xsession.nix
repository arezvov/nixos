{ config, pkgs, ... }:

{
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
        "Mod1+e" = "exec /home/alex/scripts/translate-notify";
        #"Mod1+w --release" = "exec /home/alex/scripts/cb 2&>1 /tmp/cb.log";
        "control+Mod1+l" = "exec ${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 15 20";
        "${mod}+q" = "exec clipcat-menu";
        #"${mod}+q" = "exec CM_HISTLENGTH=30 clipmenu -i -fn Terminus:size=10 -nb '#002b36' -nf '#839496' -sb '#073642' -sf '#93a1a1'";
        # "control+Mod1+l" = "exec ${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 3 10";
        #"${mod}+q" =
        #  "exec CM_HISTLENGTH=30 clipmenu -i -fn Terminus:size=10 -nb '#002b36' -nf '#839496' -sb '#073642' -sf '#93a1a1'";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec dmenu_run";
        "${mod}+z" = "Fxec passmenu -l 50";

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
        "233" = "exec ${pkgs.light}/bin/light -A 5";
        "232" = "exec ${pkgs.light}/bin/light -U 5";
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
      bars = [{ command = "${pkgs.polybarFull}/bin/polybar"; }];
      terminal = "alacritty";
      workspaceAutoBackAndForth = true;
      startup = [
        {
          command = "systemctl --user restart polybar";
          always = true;
          notification = true;
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
