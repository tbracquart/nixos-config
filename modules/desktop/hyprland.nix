{ config, pkgs, lib, ... }:

let
  cfg = config.my.desktop.hyprland;
in
{
  options.my.desktop.hyprland.enable = lib.mkEnableOption
    "le gestionnaire de fenêtres Hyprland";

  config = lib.mkIf cfg.enable {
    services.libinput.enable = true;

    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      recommendedServices.enable = true;
    };

    services.displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        output.scale = 1;
        keyboard.layout = "fr";
      };      
    };
  };
}
