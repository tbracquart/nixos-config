{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    cachix
    fastfetch
    file
    pciutils
    ripgrep
    sops
    ssh-to-age
    tree
    usbutils
    peazip
    celluloid
    udiskie
    libreoffice
    inputs.omnibin.packages.${pkgs.stdenv.hostPlatform.system}.omnibin-shell
    inputs.multiverse.packages.${pkgs.stdenv.hostPlatform.system}.mvs
    (writeShellApplication {
      name = "nix-maintenance";
      runtimeInputs = [
        nix
        coreutils
        git
      ];
      text = builtins.readFile ../../scripts/nix-maintenance.sh;
    })
  ];
}
