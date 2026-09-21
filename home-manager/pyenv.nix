{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.pyenv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  home.file."${config.programs.pyenv.rootDirectory}/plugins/pyenv-virtualenv".source =
    pkgs.fetchFromGitHub
      {
        owner = "pyenv";
        repo = "pyenv-virtualenv";
        rev = "v1.2.4";
        hash = "sha256-NgtowwE1T5NoiYiL18vdpYumVuPSWoDCOyP2//d+uHk=";
      };

  programs.bash.initExtra = lib.mkAfter ''
    eval "$(pyenv virtualenv-init - bash)"
  '';

  programs.zsh.initContent = lib.mkAfter ''
    eval "$(pyenv virtualenv-init - zsh)"
  '';
}
