{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager";

    secrets.url = "git+file:///home/alex/git/nixos-secrets";
  };

  outputs = { self, nixpkgs, nixpkgs-master, ...  } @ inputs:
  let 
    pkgs = import nixpkgs { 
      inherit system;
      config.allowUnfree = true; 
    };
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      laptop = inputs.nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./configuration-laptop.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alex = import ./home-manager/default.nix;
          }
        ];
        specialArgs = { inherit inputs pkgs; };
      };
    };

    packages.x86_64-linux = (builtins.head (builtins.attrValues inputs.self.nixosConfigurations)).pkgs;

    devShell.x86_64-linux = with inputs.self.packages.x86_64-linux;
      mkShell {
        buildInputs = [
          nixUnstable
        ];
      };

  };
}
