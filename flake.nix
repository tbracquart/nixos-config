{
  description = "NixOS + Home Manager Flake pour ZenBook 13 et V145-15AST";

  nixConfig =
    let
      caches = import ./common/system/caches.nix {
        myConfig = import ./config.nix;
      };
    in
    {
      extra-substituters = caches.substituters;
      extra-trusted-public-keys = caches.trusted-public-keys;
    };

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    freesmlauncher.url = "github:FreesmTeam/FreesmLauncher/develop";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

#    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nix-openclaw = {
      url = "github:openclaw/nix-openclaw";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nix-openclaw-tools.inputs.nixpkgs.follows = "nixpkgs";
      inputs.qmd.inputs.nixpkgs.follows = "nixpkgs";
      inputs.qmd.inputs.flake-utils.follows = "flake-utils";
    };

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

  outputs = { nixpkgs, ... }@inputs:
    let
      myConfig = import ./config.nix;
      repoSource = nixpkgs.lib.fileset.toSource {
        root = ./.;
        # Cette liste doit rester alignée avec les paths-ignore de
        # .github/workflows/build-installer-iso.yml.
        fileset = nixpkgs.lib.fileset.difference ./.
          (nixpkgs.lib.fileset.unions [ ./.github ./README.md ./.gitignore ]);
      };
    in
    {
      nixosConfigurations.installer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          modulesPath = "${nixpkgs}/nixos/modules";
          inherit repoSource;
        };
        modules = [ ./installer/iso.nix ];
      };

      nixosConfigurations.ZenBook-13 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs myConfig; };
        modules = [ ./hosts/ZenBook-13/configuration.nix ];
      };

      nixosConfigurations.V145-15AST = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs myConfig; };
        modules = [ ./hosts/V145-15AST/configuration.nix ];
      };
    };
}
