{ pkgs, ... }:

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
  ];
}
