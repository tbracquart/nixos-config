{ inputs, ... }:

{
  imports = [
    ./system/locale.nix
    ./system/networking.nix
    ./system/nix.nix
    ./system/packages.nix
    ./system/programs.nix
    ./system/security.nix
    ./system/services.nix
    ./system/shell.nix
    ./users/thibaut.nix
    ../modules
    ../profiles
    inputs.home-manager.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];
}
