{ config, lib, pkgs, pkgs-master, mkDerivation, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    libguestfs-with-appliance
    vim
    pkgs-master.tdesktop
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
    # ipmi
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
    teamviewer
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
    jetbrains.phpstorm
    jetbrains.goland
    bfg-repo-cleaner
    gnumake
    iotop
    iotop-c
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
    jetbrains.clion
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
    # docker-machine-kvm2
    kubectl
    kubernetes-helm
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
    pkgs-master.terraform-full
    pkgs-master.terraform-provider-libvirt
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
    exfat-utils
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
    python39Packages.python-gitlab
    (python39.withPackages (ps: with ps; [ pip python-gitlab ]))
  ];
  fonts.fonts = with pkgs; [ jetbrains-mono siji ];
}
