# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
 
{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration-home.nix
      ./pkgs.nix
      ./environment.nix
      ./users.nix
      ./services.nix
      ./hosts.nix
    ];

  boot = {
    loader.grub = {
      enable = true;
      useOSProber = true;
      device = "/dev/sda"; # or "nodev" for efi only
      default = 2;
    };

    kernelPackages = pkgs.linuxPackages_6_12;
    kernel.sysctl = {
      "net.ipv4.ip_default_ttl" = 65;
      "kernel.perf_event_paranoid" = 1;
    };
  };

  #nixpkgs.config.permittedInsecurePackages = [ "openssl-1.0.2u" ];

  #hardware.opengl.driSupport32Bit = true;
  programs = {
    steam.enable = true;
    adb.enable = true;
  };

  services.ntp.enable = true;

  # services.teamviewer.enable = true;

  #zramSwap = {
  #  enable = true;
  #  numDevices = 12;
  #  memoryPercent = 100;
  #};

  security.wrappers = {
    # ubridge = {
    #  source  = "${pkgs.ubridge}/bin/ubridge";
    #  capabilities = "cap_net_admin,cap_net_raw=ep";
    # };
    iotopc = {
      owner = "root";
      group = "root";
      source = "${pkgs.iotop-c}/bin/iotop-c";
      capabilities = "cap_net_admin+eip";
    };
  };

  virtualisation = {
    incus = {
      enable = true;
      ui.enable = true;
    };
  };

  networking = {
    hostName = "home";
    useDHCP = false;
    firewall.enable = false;
    interfaces.enp13s0.useDHCP = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    dpi = 140;

    xrandrHeads = [{
        output = "DP-2";
        primary = true;
      } {
        output = "DP-0";
      }
    ];

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu polybarFull i3lock-fancy i3lock-fancy-rapid
      ];
    };
  };

  services = {
    udev = {
      extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d030", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"

        # Atmel DFU
        ### ATmega16U2
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2fef", TAG+="uaccess"
        ### ATmega32U2
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff0", TAG+="uaccess"
        ### ATmega16U4
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff3", TAG+="uaccess"
        ### ATmega32U4
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", TAG+="uaccess"
        ### AT90USB64
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff9", TAG+="uaccess"
        ### AT90USB162
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ffa", TAG+="uaccess"
        ### AT90USB128
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ffb", TAG+="uaccess"

        # Input Club
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1c11", ATTRS{idProduct}=="b007", TAG+="uaccess"

        # STM32duino
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1eaf", ATTRS{idProduct}=="0003", TAG+="uaccess"
        # STM32 DFU
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", TAG+="uaccess"

        # BootloadHID
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05df", TAG+="uaccess"

        # USBAspLoader
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", TAG+="uaccess"

        # USBtinyISP
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1782", ATTRS{idProduct}=="0c9f", TAG+="uaccess"

        # ModemManager should ignore the following devices
        # Atmel SAM-BA (Massdrop)
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"

        # Caterina (Pro Micro)
        ## pid.codes shared PID
        ### Keyboardio Atreus 2 Bootloader
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2302", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        ## Spark Fun Electronics
        ### Pro Micro 3V3/8MHz
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9203", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        ### Pro Micro 5V/16MHz
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9205", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        ### LilyPad 3V3/8MHz (and some Pro Micro clones)
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9207", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        ## Pololu Electronics
        ### A-Star 32U4
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1ffb", ATTRS{idProduct}=="0101", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        ## Arduino SA
        ### Leonardo
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0036", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        ### Micro
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0037", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        ## Adafruit Industries LLC
        ### Feather 32U4
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="000c", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        ### ItsyBitsy 32U4 3V3/8MHz
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="000d", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        ### ItsyBitsy 32U4 5V/16MHz
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="000e", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        ## dog hunter AG
        ### Leonardo
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2a03", ATTRS{idProduct}=="0036", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        ### Micro
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2a03", ATTRS{idProduct}=="0037", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"

        # hid_listen
        KERNEL=="hidraw*", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"

        # hid bootloaders
        ## QMK HID
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2067", TAG+="uaccess"
        ## PJRC's HalfKay
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="0478", TAG+="uaccess"

        # APM32 DFU
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="314b", ATTRS{idProduct}=="0106", TAG+="uaccess"

        # GD32V DFU
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="28e9", ATTRS{idProduct}=="0189", TAG+="uaccess"

        # WB32 DFU
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="342d", ATTRS{idProduct}=="dfa0", TAG+="uaccess"

        # AT32 DFU
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", TAG+="uaccess"

      '';
    };

    displayManager = {
        defaultSession = "none+i3";
        #lightdm.greeters.pantheon.enable = true;
    };

    pulseaudio = {
      enable = false;
    };

    pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
    };
  };

  nix = {
    # gc.automatic = true;
    # gc.options = "--delete-older-than 14d";
    settings.require-sigs = false;
    #package = pkgs.nixUnstable;
    extraOptions = ''
      binary-caches = https://cache.nixos.org/
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = "24.11"; # Did you read the comment?

}

