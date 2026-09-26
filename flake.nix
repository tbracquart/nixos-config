{
  description = "NixOS + Home Manager Flake pour ZenBook 13 et V145-15AST";

  nixConfig = {
    extra-substituters = [
      "https://tbracquart.cachix.org"
      "https://nix-community.cachix.org"
      "https://attic.xuyh0120.win/lantian"
      "https://freesmlauncher.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "tbracquart.cachix.org-1:eTT16nwdreuvu4yagVFB1p+PeRg8ZCZsCA8648IJCZU="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "freesmlauncher.cachix.org-1:Jcp5Q9wiLL+EDv8Mh7c6L9xGk+lXr7/otpKxMOuBuDs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    freesmlauncher.url = "github:FreesmTeam/FreesmLauncher/develop";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    omnibin = {
      url = "github:fzakaria/omnibin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    multiverse.url = "github:fzakaria/nixpkgs-multiverse";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations.installer = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        modulesPath = "${nixpkgs}/nixos/modules";
        repoSource = ./.;
      };
      modules = [ ./installer/iso.nix ];
    };

    nixosConfigurations.ZenBook-13 = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./hosts/ZenBook-13/configuration.nix ];
    };

    nixosConfigurations.V145-15AST = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./hosts/V145-15AST/configuration.nix ];
    };
  };
}
