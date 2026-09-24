{ config, lib, ... }:

let
  cfg = config.my.authentication.howdy;
in
{
  options.my.authentication.howdy.enable = lib.mkEnableOption
    "l'authentification faciale avec Howdy";

  config = lib.mkIf cfg.enable {
    services.howdy = {
      enable = true;
      control = "sufficient";
    };
  };
}
