# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  pa-volume = pkgs.writeScript "pa-volume" ''
    #!${pkgs.bash}/bin/bash

    for sink in $(${pkgs.pulseaudio}/bin/pactl list sinks | grep "Sink #" | cut -b7-);
    do
        ${pkgs.pulseaudio}/bin/pactl -- set-sink-volume $sink $1%
    done
  '';

  pa-mute = pkgs.writeScript "pa-mute" ''
    #!${pkgs.bash}/bin/bash

    for sink in $(${pkgs.pulseaudio}/bin/pactl list sinks | grep "Sink #" | cut -b7-);
    do
        ${pkgs.pulseaudio}/bin/pactl -- set-sink-mute $sink toggle;
    done
  '';

in
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration-laptop.nix
    ./pkgs.nix
    ./environment.nix
    ./users.nix
    ./services.nix
    ./hosts.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    memtest86.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_5_10;
  boot.kernel.sysctl = {
    "net.ipv4.ip_default_ttl" = 65;
    "kernel.perf_event_paranoid" = 1;
    "net.ipv4.ip_nonlocal_bind" = 1;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.0.2u"
  ];

  hardware.graphics.enable32Bit = true;
  programs = {
    # steam.enable = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  security.wrappers = {
    ubridge = {
      owner = "root";
      group = "root";
      source = "${pkgs.ubridge}/bin/ubridge";
      capabilities = "cap_net_admin,cap_net_raw=ep";
    };
  };

  networking = {
    hostName = "laptop";
    useDHCP = false;
    interfaces.wlan0.useDHCP = true;
    interfaces.enp3s0f4u1.useDHCP = true;
  };

  services.acpid = {
    enable = true;
    logEvents = true;
    acEventCommands = ''
      # ac_adapter ACPI0003:00 00000080 00000000
      export PATH=${pkgs.gawk}/bin:${pkgs.linuxPackages_5_10.cpupower}/bin:$PATH

      AC_STATUS=$(echo $1 | awk '{print $4}')

      if [[ $AC_STATUS == 00000001 ]]; then
        cpupower frequency-set --max 2100000 --governor performance
      else
        cpupower frequency-set --max 1400000 --governor powersave
      fi
    '';
  };

  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = [ ];
    };
  };

  services.displayManager.defaultSession = "none+i3";

  services.pulseaudio.enable = lib.mkForce false;

  nix = {
    gc.automatic = true;
    gc.options = "--delete-older-than 14d";
    package = pkgs.nix;
    settings.require-sigs = false;
    extraOptions = ''
      binary-caches = https://cache.nixos.org/
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = "20.03"; # Did you read the comment?

}
