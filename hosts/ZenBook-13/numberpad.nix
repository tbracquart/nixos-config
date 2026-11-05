{ inputs, myConfig, ... }:

{
  imports = [
    inputs.asus-numberpad-driver.nixosModules.default
  ];

  nixpkgs.overlays = [
    inputs.asus-numberpad-driver.overlays.default
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
    defaultConfig.main = {
      activation_time = "0.25";
      default_backlight_level = "0x41";
    };
  };
}
