{ config, lib, pkgs, pkgs-master, mkDerivation, inputs, system, ... }:
let
  ovs = pkgs.python39.pkgs.buildPythonPackage rec {
    pname = "ovs";
    version = "2.13.3";

    src = pkgs.python39.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-i0bOyGWja/p4Y98p9PdhWJweB1331KovrtxS/h49gLY=";
    };
    doCheck = false;

    buildInputs = with pkgs; [
      python39Packages.sortedcontainers
    ];
  };

in {
  environment.systemPackages = with pkgs; [
    (inputs.ipmi.packages."x86_64-linux".ipmi)
    wget
    libguestfs-with-appliance
    vim
    pkgs-master.tdesktop
    slack
    #xfce4-14.xfce4-terminal
    vscode
    virtualbox
    htop
    geany
    pavucontrol
    git
    openvpn
    nix-bash-completions
    xsel
    dunst
    libnotify
    xdotool
    dnsutils
    swaks
    #xfce4-14.xfce4-screenshooter
    zip
    irssi
    whois
    ltrace
    sysbench
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
    inetutils
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
    dpkg
    unzip
    pandoc
    woof
    docker-compose
    mariadb
    mutt
    qbittorrent
    nodePackages.node2nix
    # nodejs-12_x
    php
    yarn
    flameshot
    gimp
    virt-manager
    vlc
    #jetbrains.pycharm-community
    gcc
    bvi
    file
    sqlite
    nixfmt
    # teamviewer
    ansible
    openssl
    quassel
    # palemoon
    # streamlink
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
    #jetbrains.phpstorm
    #jetbrains.goland
    bfg-repo-cleaner
    gnumake
    iotop
    iotop-c
    perl
    valgrind
    # atom
    exim
    lsof
    qtcreator
    automake
    # nmap
    # nmap-graphical
    gtk2
    gtk2-x11
    pkgs-master.discord
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
    ntfs3g
    blktrace
    p7zip
    tmux
    pinentry-curses
    # steam
    #jetbrains.clion
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
    # teams
    openttd
    pkgs-master.minikube
    # docker-machine-kvm2
    kubectl
    kubernetes-helm
    linuxPackages_5_10.cpupower
    linuxPackages_5_10.bpftrace
    linuxPackages_5_10.sysdig
    fwupd
    innoextract
    efitools
    #minecraft
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
    #pkgs-master.terraform-full
    #pkgs-master.terraform-provider-libvirt
    cdrkit
    ipcalc
    bridge-utils
    lgogdownloader
    virt-what
    # mininet
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
    exfat
    clair
    libcgroup
    vmtouch
    spotify
    pulseaudioFull
    noisetorch
    prometheus
    sshpass
    ubridge
    vpcs
    python39Packages.pip
    (python39.withPackages (ps: with ps; [ pip python-gitlab ovs ]))
    element-desktop
    pwgen
    tcpdump
    yq
  ];
  fonts.fonts = with pkgs; [ jetbrains-mono siji ];
}
