{ config, inputs, myConfig, pkgs, ... }:

let
  numberpadDriver = pkgs.asus-numberpad-driver.overrideAttrs (old: {
    # Install the four-level layout and apply the targeted upstream fixes.
    postInstall = (old.postInstall or "") + ''
      install -Dm644 ${./numberpad-layout.py} $out/share/asus-numberpad-driver/layouts/up5401ea.py
    '';

    patches = (old.patches or []) ++ [ ./numberpad.patch ];
  });
in

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
    package = numberpadDriver;
    layout = "up5401ea";
    wayland = true;
    # %t resolves to the current user's runtime directory in systemd.
    runtimeDir = "%t/";
    dbusSessionBusAddress = "unix:path=%t/bus";
    # Do not hard-code WAYLAND_DISPLAY: it may differ between sessions.
    ignoreWaylandDisplayEnv = true;
    defaultConfig.main = {
      activation_time = "0.25";
      default_backlight_level = "0x41";
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
  my.virtualisation.libvirt.user = myConfig.username;
}
