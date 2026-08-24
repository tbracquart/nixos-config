{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/home/00-options.nix
    ./modules/home/01-packages.nix
    ./modules/home/03-fish.nix
    ./modules/home/04-firefox.nix
    ./modules/home/05-hyprland-noctalia.nix
    ./modules/home/06-session.nix
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
}
