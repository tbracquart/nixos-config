{ config, lib, ... }:

{
  options.my.flakePath = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/nixos-config";
    description = "Chemin absolu vers le dépôt nixos-config";
  };
}
