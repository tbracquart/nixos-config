{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ../../common
    ../../users/thibaut/storage.nix
  ];

  networking.hostName = "ZenBook-13";
  system.stateVersion = "26.05";

  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users.thibaut = {
      imports = [
        ../../users/thibaut/base
        ../../users/thibaut/variants/zenbook.nix
      ];
    };
  };

  my.profile = "laptop";
  my.authentication.howdy.ir.enable = true;
  my.bluetooth.powerOnBoot = true;
  my.compatibility.nix-ld.enable = true;
  my.desktop.hyprland.enable = true;
  my.graphics.intel.enable = true;
  my.location.geoclue2.enable = true;
  my.virtualisation.libvirt.enable = true;
  my.virtualisation.libvirt.user = "thibaut";
}
