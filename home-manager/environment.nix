{ ... }:

{
  home.sessionVariables = {
    ARGOCD_OPTS = "--grpc-web";
    SYSTEMD_PAGER = "";
    NIXOS_CONFIG = "/home/alex/nixos/configuration.nix";
    LIBVIRT_DEFAULT_URI = "qemu:///system";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  home.file.".nanorc".text = ''
    set tabstospaces
    set tabsize 4
  '';
}
