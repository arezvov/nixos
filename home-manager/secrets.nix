{ config, pkgs, ... }:

{
  home.packages = [ pkgs.sops ];

  sops = {
    gnupg.home = "${config.home.homeDirectory}/.gnupg";
    defaultSopsFile = ../secrets/vault.yaml;
    secrets.vault_password = {
      path = "${config.home.homeDirectory}/.vault_password_file";
      mode = "0600";
    };
  };
}
