{ config, lib, myConfig, pkgs, ... }:

let
  homeDirectory = config.users.users.${myConfig.username}.home;
  caches = import ./caches.nix { inherit myConfig; };
in

{
  nixpkgs.config.allowUnfree = true;

  # Compatibilité temporaire avec sops-nix qui référence encore ce builder.
  nixpkgs.overlays = [
    (final: prev: {
      buildGo125Module = final.buildGoModule;

      # Contourne le renommage PEGTL incorrect de VTK 9.5.2 dans nixpkgs-unstable.
      vtk_9_5 = prev.vtk_9_5.overrideAttrs (_: {
        postPatch = "";
      });
    })
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];

      # Déduplique les fichiers identiques à chaque ajout au magasin.
      auto-optimise-store = true;

      # Lance une collecte en cours de construction si l'espace devient faible.
      # Nix s'arrête dès que max-free est atteint ou qu'il n'y a plus de déchets.
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 10 * 1024 * 1024 * 1024;

      substituters =
        caches.personalSubstituters
        ++ [ "https://cache.nixos.org" ]
        ++ caches.publicSubstituters;

      trusted-public-keys =
        [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ]
        ++ caches.personalTrustedPublicKeys
        ++ caches.publicTrustedPublicKeys;

      netrc-file = "/run/secrets/github-netrc";
    };

    gc = {
      automatic = true;
      dates = "weekly";
      # Supprime les générations de plus de sept jours.
      options = "--delete-older-than 7d";
    };
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets."github-netrc" = {
      path = "/run/secrets/github-netrc";
      mode = "0400";
    };

    secrets."cachix-auth-token" = lib.mkIf myConfig.cachix.enable {
      path = "/run/secrets/cachix-auth-token";
      mode = "0400";
    };
  };

  system.activationScripts.cachixAuthtoken = lib.mkIf myConfig.cachix.enable {
    text = ''
      if [ -f /run/secrets/cachix-auth-token ]; then
        if id -u ${myConfig.username} >/dev/null 2>&1; then
          mkdir -p ${homeDirectory}/.config/cachix
          if ! cat /run/secrets/cachix-auth-token | runuser -u ${myConfig.username} -- ${pkgs.cachix}/bin/cachix authtoken --stdin; then
            echo "Avertissement : impossible d'activer le token Cachix pour ${myConfig.username}." >&2
          fi
          chown -R ${myConfig.username}:users ${homeDirectory}/.config/cachix
        fi
      fi
    '';
  };
}
