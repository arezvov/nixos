# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  services.nix-daemon.enable = true;
  ids.uids.nixbld = 300;

  users.users."a.rezvov" = {
    name = "a.rezvov";
    home = "/Users/a.rezvov";
  };
}
