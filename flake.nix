{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    # nixpkgs-dev.url = "git+file:///home/alex/src/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    secrets.url = "git+file:///home/alex/git/nixos-secrets";
  };

  outputs = { 
    self, 
    nixpkgs, 
    nixpkgs-master,
    nix-darwin,
    # nixpkgs-dev, 
    ...  
  } @ inputs:
  let 
    pkgs = import nixpkgs { 
      inherit system;
      config.allowUnfree = true; 
    };
    pkgs-master = import nixpkgs-master {
      inherit system;
      config.allowUnfree = true;
    };
    # pkgs-dev = import nixpkgs-dev {
    #   inherit system;
    # };
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      laptop = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration-laptop.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alex = import ./home-manager/default.nix;
          }
        ];
        specialArgs = { 
          inherit inputs system pkgs pkgs-master self;
          # inherit pkgs-dev;
        };
      };
      home = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration-home.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alex = import ./home-manager/default.nix; 
          }
        ];
        specialArgs = {
          inherit inputs pkgs pkgs-master self;
        };
      };
    };

    darwinConfigurations = {
      "vk_macbook" = nix-darwin.lib.darwinSystem {
        modules = [ 
          ./configuration-macos.nix 
          
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              backupFileExtension = "nix-hm-backup";
              users = {
                "a.rezvov" = import ./home-manager/default-mac.nix; 
              };
            };
          }
        ];
      };
    };
     
    darwinPackages = self.darwinConfigurations."vk_macbook".pkgs;

    packages.x86_64-linux = (builtins.head (builtins.attrValues inputs.self.nixosConfigurations)).pkgs;

    devShell.x86_64-linux = with inputs.self.packages.x86_64-linux;
      mkShell {
        buildInputs = [
          nixUnstable
        ];
      };

  };
}
