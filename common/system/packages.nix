{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    file
    pciutils
    sops
    ssh-to-age
    usbutils
  ];
}
