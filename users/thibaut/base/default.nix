{ config, pkgs, ... }:

{
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
    NIXCFG = config.my.flakePath;
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
  };
  
  imports = [
    ./00-options.nix
    ./01-packages.nix
    ./02-git.nix
    ./03-fish.nix
  ];
}
