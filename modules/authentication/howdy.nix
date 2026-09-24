{ config, lib, pkgs, ... }:

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

      # Graphical PAM clients such as Noctalia can submit an empty password
      # to start authentication. Upstream Howdy 3.0.0 treats that empty
      # conversation as a completed password attempt and returns PAM_IGNORE,
      # which makes pam_unix reject the transaction before face recognition
      # finishes. Keep the face authentication running for empty submissions.
      package = pkgs.howdy.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ../../patches/howdy-empty-password.patch
        ];
      });
    };

    # Howdy's PAM module needs /dev/uinput for the global "input" workaround.
    # NixOS also creates the udev rule and the dedicated group for the device.
    hardware.uinput.enable = true;
  };
}
