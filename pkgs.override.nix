{ pkgs, config, ... }:

let 
  master = import (builtins.fetchGit {
    url = "https://gitlab.intr/nixos/nixpkgs.git";
    ref = "master";
#    sha256 = "1zrqay3278iqj0xblf99swiax9xq56phb5nqqj4aqq3rx056kkna";
  }) { config = config; };

  nixos-master = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs";
    ref = "master";
  }) { config.allowUnfreePredicate = (pkg: true); };

  nixos2003 = import (pkgs.fetchgit {
    url = "https://github.com/NixOS/nixpkgs";
    rev = "c7153272cb196169f1dc67383f8bdddb17d7eaf6";
    sha256 = "1ni9zn7f8y5is04srlm522jgwgq9yqhvi9pwvk9x79ghhslasads";
  }) {};

  nixos-tf = import (pkgs.fetchgit {
    url = "https://github.com/NixOS/nixpkgs";
    rev = "81fe5e0bf91c60314f2d64b06e3c58cbc7e67ac2";
    sha256 = "0l6pdgi6nkkgnv5sph61kh5rb3y321hap5m94g44b10kfh8272ck";
  }) { };

in
{
  nixpkgs.config.packageOverrides = pkgs: rec {
    myNeovim = pkgs.neovim.override {
      configure = {
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [ vim-nix ];
          opt = [ ];
        };      
      };
    };

    ipmi = pkgs.callPackage (builtins.fetchGit { url = "https://gitlab.intr/utils/nix-ipmi.git"; ref = "master";} ) {};
    teams = nixos-master.teams;
    terraform = nixos-tf.terraform_0_13;
    terraform-provider-libvirt = nixos-master.terraform-provider-libvirt;
    openvswitch = nixos-master.openvswitch;
    rclone = nixos-master.rclone;
#    minikube = nixos-master.minikube;
#    kubectl = nixos-master.kubectl;
#    polybarFull = nixos-master.polybar;
#    scilab-bin = nixos-master.scilab-bin;
    minecraft = nixos-master.minecraft;
    htop = nixos-master.htop;
#    discord-new = master.discord-canary;
#    tdesktop = nixos2003.tdesktop;
#    streamlink = nixos2003.streamlink;
#    clipmenu = nixos2003.clipmenu;
#    ipmiview = pkgs.callPackage ./pkgs/ipmiview { };
    ventoy = pkgs.callPackage ./pkgs/ventoy { };
    multimc = pkgs.callPackage ./pkgs/multimc { qtbase = pkgs.qt5.qtbase; };
  };
}
