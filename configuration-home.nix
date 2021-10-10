# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
    secrets = inputs.secrets.secrets;
in {
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration-home.nix
      ./pkgs.nix
      ./environment.nix
      ./users.nix
      ./services.nix
      ./hosts.nix
      ./openvpn.nix
    ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda"; # or "nodev" for efi only
    };

    kernelPackages = pkgs.linuxPackages_5_10;
    kernel.sysctl = {
      "net.ipv4.ip_default_ttl" = 65;
      "kernel.perf_event_paranoid" = 1;
    };
  };

  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.0.2u" ];

  hardware.opengl.driSupport32Bit = true;
  programs = {
    # steam.enable = true;
    adb.enable = true;
  };

  zramSwap = {
    enable = true;
    numDevices = 12;
    memoryPercent = 100;
  };

  security.wrappers = {
    ubridge = {
      source  = "${pkgs.ubridge}/bin/ubridge";
      capabilities = "cap_net_admin,cap_net_raw=ep";
    };
  };

  networking = {
    hostName = "home";
    useDHCP = false;
    firewall.enable = false;
    interfaces.enp4s0.useDHCP = true;
  };

  services.openvpn.servers = {
    mj = {
      config = "config /etc/openvpn/mj.conf";
      autoStart = true;
      updateResolvConf = true;
    };
  };

  services.xserver = {
    enable = true;
    displayManager = {
        defaultSession = "none+i3";
        #lightdm.greeters.pantheon.enable = true;
    };

    xrandrHeads = [{
        output = "DP-2";
        primary = true;
      } {
        output = "DVI-D-1";
      }
    ];

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu polybarFull i3lock-fancy i3lock-fancy-rapid
      ];
    };
  };

  nix = {    
    # gc.automatic = true;
    # gc.options = "--delete-older-than 14d";
    requireSignedBinaryCaches = false;
    package = pkgs.nixUnstable;
    extraOptions = ''
      binary-caches = https://cache.nixos.org/ 
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = "20.03"; # Did you read the comment?

}

