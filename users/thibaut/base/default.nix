{ config, pkgs, lib, inputs, ... }:

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
    ./options.nix
    ./packages.nix
    ./git.nix
    ./fish.nix
  ];
}
