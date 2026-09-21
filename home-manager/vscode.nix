{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs; [
      vscode-extensions.hashicorp.hcl
      vscode-extensions.hashicorp.terraform
      vscode-extensions.jnoortheen.nix-ide
      vscode-extensions.tamasfe.even-better-toml
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        publisher = "openai";
        name = "chatgpt";
        version = "26.908.40401";
        arch = "linux-x64";
        sha256 = "0i62shawwyhbmkkiwmd8gy3nffx5crk3qd05z68z0b92h3a16vab";
      }
    ];
  };
}
