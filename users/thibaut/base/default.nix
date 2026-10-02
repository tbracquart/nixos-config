{ config, pkgs, lib, ... }:

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

  home.activation.setNixosConfigIcon = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.glib}/bin/gio set \
      -t string \
      ${config.my.flakePath} \
      metadata::custom-icon-name \
      distributor-logo-nixos
  '';

  imports = [
    ./00-options.nix
    ./01-packages.nix
    ./02-git.nix
    ./03-fish.nix
  ];
}
