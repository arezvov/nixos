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

  kubernetes = pkgs.kubernetes.overrideAttrs (old: rec {
    version = "1.28.3"; # usually harmless to omit
    src = pkgs.fetchFromGitHub {
      owner = "kubernetes";
      repo = "kubernetes";
      rev = "v${version}";
      hash = "sha256-lb9FAk3b6J92viyHzLCzbYRxhQS94/FQvDr1m1kdTq8=";
    };
  });

  kubectl = kubernetes.overrideAttrs (_: rec {
    pname = "kubectl";

    outputs = [ "out" "man" "convert" ];

    WHAT = lib.concatStringsSep " " [
      "cmd/kubectl"
      "cmd/kubectl-convert"
    ];

    installPhase = ''
      runHook preInstall
      install -D _output/local/go/bin/kubectl -t $out/bin
      install -D _output/local/go/bin/kubectl-convert -t $convert/bin

      installManPage docs/man/man1/kubectl*

      installShellCompletion --cmd kubectl \
        --bash <($out/bin/kubectl completion bash) \
        --fish <($out/bin/kubectl completion fish) \
        --zsh <($out/bin/kubectl completion zsh)
      runHook postInstall
    '';
  });

in {
  environment.systemPackages = 
  with pkgs; [
    wget
    libguestfs-with-appliance
    vim
    pkgs-master.telegram-desktop
    obsidian
    pkgs-master.nekoray
    pkgs-master.vscode-fhs
    pkgs-master.code-cursor
    pkgs-master.prismlauncher
    pkgs-master.winbox4
    htop
    pavucontrol
    git
    nix-bash-completions
    xsel
    dunst
    libnotify
    xdotool
    dnsutils
    swaks
    zip
    irssi
    whois
    ltrace
    sysbench
    # simplescreenrecorder
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
    killall
    dive
    redis
    jdk11
    temurin-bin-17
    adoptopenjdk-icedtea-web
    xorg.xbacklight
    dpkg
    unzip
    pandoc
    docker-compose
    mariadb
    mutt
    qbittorrent
    nodePackages.node2nix
    php
    yarn
    flameshot
    gimp
    virt-manager
    vlc
    gcc
    bvi
    file
    sqlite
    nixfmt-classic
    ansible
    ansible-lint
    openssl
    quassel
    imagemagick
    parallel
    netcat
    netcat-gnu
    lsscsi
    fwts
    pciutils
    atop
    cpufrequtils
    bfg-repo-cleaner
    gnumake
    iotop
    iotop-c
    perl
    valgrind
    lsof
    automake
    gtk2
    gtk2-x11
    pkgs-master.discord
    screen
    davfs2
    wine
    winePackages.stable
    dmidecode
    iperf3
    unrar
    libchardet
    hwloc
    pkgs-master.google-chrome
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
    go
    radare2
    xrdp
    openttd
    pkgs-master.minikube
    kubectl
    kubernetes-helm
    fwupd
    innoextract
    efitools
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
    pkgs-master.terraform
    pkgs-master.terraform-providers.incus
    cdrkit
    ipcalc
    bridge-utils
    lgogdownloader
    virt-what
    bluetui
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
    pulseaudioFull
    noisetorch
    sshpass
    ubridge
    vpcs
    pwgen
    tcpdump
    yq
    btop
    remmina
    fpm
    uv
    ruff
  ];
  fonts.packages = with pkgs; [ jetbrains-mono siji ];

}
