{ config, inputs, myConfig, ... }:

{
  imports = [
    inputs.asus-numberpad-driver.nixosModules.default
    ./hardware-configuration.nix
    ./boot.nix
    ../../common
    ../../users/thibaut/storage.nix
  ];

  nixpkgs.overlays = [
    inputs.asus-numberpad-driver.overlays.default
  ];

  # The driver needs access to the I²C and input devices.
  users.users.${myConfig.username}.extraGroups = [ "i2c" "input" ];

  networking.hostName = "ZenBook-13";
  system.stateVersion = "26.05";

#  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs myConfig; };

    users.${myConfig.username} = {
      imports = [
        ../../users/thibaut/base
        ../../users/thibaut/variants/zenbook.nix
      ];
    };
  };

  hardware.asus-numberpad-driver = {
    enable = true;
    layout = "up5401ea";
    wayland = true;
    runtimeDir = "/run/user/${toString config.users.users.${myConfig.username}.uid}/";
    dbusSessionBusAddress = "unix:path=/run/user/${toString config.users.users.${myConfig.username}.uid}/bus";
    # Do not hard-code WAYLAND_DISPLAY: it may differ between sessions.
    ignoreWaylandDisplayEnv = true;
  };

  my.profile = "laptop";
  my.authentication.howdy.ir.enable = true;
  my.bluetooth.powerOnBoot = true;
  my.compatibility.nix-ld.enable = true;
  my.desktop.hyprland.enable = true;
  my.graphics.intel.enable = true;
  my.location.geoclue2.enable = true;
  my.virtualisation.libvirt.enable = true;
  my.virtualisation.libvirt.user = myConfig.username;
}
