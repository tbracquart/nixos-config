{ inputs, myConfig, ... }:

{
  imports = [
    inputs.asus-numberpad-driver.nixosModules.default
  ];

  nixpkgs.overlays = [
    inputs.asus-numberpad-driver.overlays.default
    (final: prev: {
      asus-numberpad-driver = prev.asus-numberpad-driver.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ../../patches/asus-numberpad-driver-initialize-brightness.patch
        ];
      });
    })
  ];

  # The driver needs access to the I²C and input devices.
  users.users.${myConfig.username}.extraGroups = [ "i2c" "input" ];

  hardware.asus-numberpad-driver = {
    enable = true;
    layout = "up5401ea";
    wayland = true;
    runtimeDir = "%t/";
    dbusSessionBusAddress = "unix:path=%t/bus";
    ignoreWaylandDisplayEnv = true;
    # Seeds the user configuration on first launch; an existing numberpad_dev is preserved.
    defaultConfig.main = {
      activation_time = "0.25";
      default_backlight_level = "0x41";
      enabled_touchpad_pointer = "0";
    };
  };
}
