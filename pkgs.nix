{ config, lib, pkgs, mkDerivation, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    libguestfs-with-appliance
    vim
    myNeovim
    tdesktop
    slack
    xfce4-14.xfce4-terminal
    vscode
    virtualbox
    htop
    geany
    pavucontrol
    git
    openvpn
    nix-bash-completions
    php74Packages.composer2
    xsel
    dunst
    libnotify
    xdotool
    dnsutils
    swaks
    xfce4-14.xfce4-screenshooter
    zip
    irssi
    whois
    ltrace
    sysbench
    emacs
    simplescreenrecorder
    thunderbird
    feh
    robo3t
    clipit
    dzen2
    sshfs
    libidn2
    jq
    mtr
    perl
    sieve-connect
    telnet
    xdotool
    tigervnc
    mycli
    xorg.xhost
    bc
    lua5_3
    lua53Packages.luaposix
    ipmitool
    killall
    dive
    redis
    jre
    adoptopenjdk-icedtea-web
    xorg.xbacklight
    ipmi
    dpkg
    unzip
    pandoc
    woof
    docker-compose
    mariadb
    mutt
    qbittorrent
    nodePackages.node2nix
    nodejs-12_x
    php
    yarn
    flameshot
    gimp
    virtmanager
    vlc
    jetbrains.pycharm-community
    gcc
    bvi
    file
    sqlite
    nixfmt
    (with import (builtins.fetchTarball {
      url =
        "https://github.com/nixos/nixpkgs/archive/8686922e68dfce2786722acad9593ad392297188.tar.gz";
    }) {
      overlays = [
        (self: super: {
          cerbapi = (with super;
            python3.pkgs.buildPythonPackage rec {
              pname = "cerbapi";
              version = "1.0.9";
              src = python3.pkgs.fetchPypi {
                inherit pname version;
                sha256 = "1c5xahjfb60vrwn7hj0n4s66dyzsx81gai7af564n8pkbdylcz37";
              };
              doCheck = false;
            });
          clamd = (with super;
            python3.pkgs.buildPythonPackage rec {
              pname = "clamd";
              version = "1.0.2";
              src = python3.pkgs.fetchPypi {
                inherit pname version;
                sha256 = "0q4myb07gn55v9mkyq83jkgfpj395vxxmshznfhkajk82kc2yanq";
              };
              doCheck = false;
            });
          vk-api = (with super;
            python3.pkgs.buildPythonPackage rec {
              pname = "vk_api";
              version = "11.8.0";
              src = python3.pkgs.fetchPypi {
                inherit pname version;
                sha256 =
                  "1c79a607eed95e7b29bb1068167e7f8398a86cf5ed45910be2c6e03ecd0b0447";
              };
              doCheck = false;
              propagatedBuildInputs =
                [ python37Packages.six python37Packages.requests ];
            });
          ytmusicapi = (with super;
            python3.pkgs.buildPythonPackage rec {
              pname = "ytmusicapi";
              version = "0.8.0";
              src = python3.pkgs.fetchPypi {
                inherit pname version;
                sha256 =
                  "d87d2ab108d39ad9c19cdefdcdbf6a766ca5711f12c540ee09752ce78118a3d7";
              };
              doCheck = false;
              buildInputs = [ python37Packages.requests ];
            });
          tg-bot-api = (with super;
            python3.pkgs.buildPythonPackage rec {
              pname = "python-telegram-bot";
              version = "12.7";
              src = python3.pkgs.fetchPypi {
                inherit pname version;
                sha256 =
                  "218b0583afb8baeefe6f2f1ddd8f1bb1ae30f0af3ce9160a372abd2cdf258eef";
              };
              doCheck = false;
              buildInputs = [
                python37Packages.cryptography
                python37Packages.certifi
                python37Packages.future
                python37Packages.tornado
                python37Packages.decorator
              ];
            });
        })
      ];
    };

      python37.withPackages (ps:
        with ps; [
          pydbus
          notify2
          cerbapi
          pymysql
          pyopenssl
          pip
          setuptools
          slackclient
          alerta
          certifi
          pexpect
          six
          clamd
          tabulate
          vk-api
          tg-bot-api
          imaplib2
          chardet
          ytmusicapi
          beautifulsoup4
          pika
          future
          decorator
        ]))
    teamviewer
    ansible
    openssl
    quassel
    weechat
    # palemoon
    streamlink
    imagemagick
    libreoffice
    parallel
    netcat
    netcat-gnu
    lsscsi
    fwts
    pciutils
    atop
    cpufrequtils
    jetbrains.phpstorm
    jetbrains.goland
    bfg-repo-cleaner
    gnumake
    iotop
    perl
    valgrind
    atom
    exim
    lsof
    qtcreator
    automake
    nmap
    nmap-graphical
    gtk2
    gtk2-x11
    discord
    gnome3.nautilus
    mono6
    screen
    davfs2
    wine
    winePackages.stable
    dmidecode
    iperf3
    vscode
    codeblocksFull
    dovecot_pigeonhole
    unrar
    libchardet
    hwloc
    google-chrome
    patchelf
    binutils-unwrapped
    avrdude
    audit
    wireshark
    pass
    gnupg
    iotop
    ntfs3g
    blktrace
    p7zip
    tmux
    pinentry-curses
    steam
    jetbrains.clion
    multibootusb
    tmux-xpanes
    sysbench
    lm_sensors
    firefox
    pinentry-curses
    pinentry-qt
    pinentry-gtk2
    polybarFull
    fzf
    sqlitebrowser
    qt5.qtbase
    fatrace
    rustc
    cargo
    influxdb
    radare2
    xrdp
    teams
    openttd
    minikube
    kubectl
    linuxPackages_5_10.cpupower
    linuxPackages_5_10.bpftrace
    linuxPackages_5_10.sysdig
    fwupd
    innoextract
    efitools
    minecraft
    lshw
    usbutils
    simple-scan
    gdb
    jetbrains-mono
    siji
    ctop
    rr
    playerctl
    zsh
    terraform
    terraform-provider-libvirt
    cdrkit
    ipcalc
    bridge-utils
    lgogdownloader
    virt-what
    mininet
    rclone
    ffmpeg
    fio
    gns3-server
    gns3-gui
    xorg.xev
    xorg.xkill
    sysstat
    efibootmgr
    nvme-cli
    ventoy
    exfat-utils
  ];
  fonts.fonts = with pkgs; [ jetbrains-mono siji ];
}
