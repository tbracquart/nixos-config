{ config, lib, pkgs, ... }:

let
  cfg = config.my.authentication.howdy;

  # Howdy's input workaround is global to its PAM module. Build a second
  # module instance with its own config directory so it can be enabled only
  # for polkit-1.
  howdyPolkit = pkgs.howdy.overrideAttrs (old: {
    pname = "howdy-polkit";
    mesonFlags = map (
      flag: lib.replaceStrings [ "/etc/howdy" ] [ "/etc/howdy-polkit" ] flag
    ) old.mesonFlags;
  });

  howdyPolkitConfig = pkgs.formats.ini { }.generate "howdy-polkit-config.ini"
    (lib.recursiveUpdate config.services.howdy.settings {
      core.workaround = "input";
    });
in
{
  options.my.authentication.howdy = {
    enable = lib.mkEnableOption
      "l'authentification faciale avec Howdy";

    polkitInputWorkaround = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Utiliser le mode Howdy « input » uniquement pour polkit-1 afin de
        permettre la saisie du mot de passe en parallèle de la reconnaissance
        faciale.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.howdy = {
      enable = true;
      control = "sufficient";
    };

    environment.etc."howdy-polkit/config.ini" = lib.mkIf cfg.polkitInputWorkaround {
      source = howdyPolkitConfig;
    };

    security.pam.services.polkit-1 = lib.mkIf cfg.polkitInputWorkaround {
      # Replace the global Howdy rule for this PAM service with the dedicated
      # module instance configured with workaround = input.
      howdy.enable = false;
      rules.auth.howdy-polkit = {
        enable = true;
        control = config.services.howdy.control;
        modulePath = "${howdyPolkit}/lib/security/pam_howdy.so";
        order = config.security.pam.services.polkit-1.rules.auth.howdy.order;
      };
    };
  };
}
