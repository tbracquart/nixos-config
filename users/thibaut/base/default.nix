{ config, ... }:

{
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
    NIXCFG = config.my.flakePath;
  };

  imports = [
    ./00-options.nix
    ./01-packages.nix
    ./02-git.nix
    ./03-fish.nix
  ];
}
