{ config, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      scrolling = {
        history = 100000;
      };
      font = {
        size = 10.0;
      };
    };
  };
}
