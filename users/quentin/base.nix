{ pkgs, inputs, ... }:

{
  home.stateVersion = "26.05";

  # Conserver pour Quentin les paquets auparavant installés globalement.
  home.packages = (with pkgs; [
    cachix
    celluloid
    fastfetch
    libreoffice
    peazip
    ripgrep
    tree
    udiskie
  ]) ++ [
    inputs.omnibin.packages.${pkgs.stdenv.hostPlatform.system}.omnibin-shell
    inputs.multiverse.packages.${pkgs.stdenv.hostPlatform.system}.mvs
  ];
}
