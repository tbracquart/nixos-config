{ config, inputs, myConfig, pkgs, ... }:

let
  numberpadDriver = pkgs.asus-numberpad-driver.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      ./numberpad.patch
    ];

    # Use four brightness levels instead of the eight in the upstream layout.
    postInstall = (old.postInstall or "") + ''
      install -Dm644 ${./numberpad-layout.py} $out/share/asus-numberpad-driver/layouts/up5401ea.py
    '';

    # Reset the driver's brightness index whenever the default level is applied.
    postPatch = (old.postPatch or "") + ''
      substituteInPlace numberpad.py \
        --replace-fail \
        'send_value_to_touchpad(default_backlight_level)' \
        'brightness = backlight_levels.index(default_backlight_level); send_value_to_touchpad(default_backlight_level)'
    '';
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
