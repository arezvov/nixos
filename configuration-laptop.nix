# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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

    secrets = import ./secrets.nix;
in {
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./pkgs.nix
      ./pkgs.override.nix
      ./environment.nix
      ./users.nix
      #./auto-update.nix
      ./services.nix
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
  };

  nixpkgs.config.permittedInsecurePackages = [
   "openssl-1.0.2u"
  ];


  hardware.opengl.driSupport32Bit = true;
  programs = {
    steam.enable = true;
    adb.enable = true;
    mininet.enable = true;
  };

  zramSwap = {
    enable = true;
    numDevices = 12;
    memoryPercent = 100;
  };

  networking = {
    hostName = "laptop";
    useDHCP = false;
    interfaces.vswitch0.useDHCP = false;
    interfaces.wlp1s0.useDHCP = true;

    wireless.enable = true;
    wireless.networks = {
      "${secrets.home_wifi_ssid}" = {
        psk = secrets.home_wifi_pass;
        priority = 0;
      };

      "${secrets.smart_wifi_ssid}" = {
        psk = secrets.smart_wifi_pass;
        priority = 100;
      };
    };
  };

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = with pkgs; [
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 5"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 5"; }
      { keys = [ 113 ]; events = [ "key" ]; command = "${sudo}/bin/sudo -u alex ${pa-mute}"; }
      { keys = [ 114 ]; events = [ "key" ]; command = "${sudo}/bin/sudo -u alex ${pa-volume} -5"; }
      { keys = [ 115 ]; events = [ "key" ]; command = "${sudo}/bin/sudo -u alex ${pa-volume} +5"; }
    ];
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
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu polybarFull i3lock-fancy i3lock-fancy-rapid
      ];
    };
    synaptics.enable = true;
  };


  nix = {    
    gc.automatic = true;
    gc.options = "--delete-older-than 14d";
    requireSignedBinaryCaches = false;
    extraOptions = ''
      binary-caches = https://cache.nixos.org/ http://jenkins.intr:5000/
    '';
  };

  system.stateVersion = "20.03"; # Did you read the comment?

}

