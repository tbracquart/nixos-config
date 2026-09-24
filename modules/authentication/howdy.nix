{ config, lib, ... }:

let
  cfg = config.my.authentication.howdy;
in
{
  options.my.authentication.howdy.enable = lib.mkEnableOption
    "l'authentification faciale avec Howdy";

  config = lib.mkIf cfg.enable {
    services.howdy = {
      enable = true;
      control = "sufficient";

      # Keep password entry available while Howdy performs face recognition.
      # Howdy's input workaround sends Enter through /dev/uinput when the
      # face is recognized first.
      settings.core.workaround = "input";
    };

    # Howdy's PAM module needs /dev/uinput for the global "input" workaround.
    # NixOS also creates the udev rule and the dedicated group for the device.
    hardware.uinput.enable = true;
  };
}
