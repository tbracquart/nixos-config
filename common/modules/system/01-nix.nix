{ config, pkgs, lib, inputs, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];

      substituters = [
        "https://tbracquart.cachix.org"
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://attic.xuyh0120.win/lantian"
        "https://freesmlauncher.cachix.org"
        "https://noctalia.cachix.org"
      ];

      trusted-public-keys = [
        "tbracquart.cachix.org-1:eTT16nwdreuvu4yagVFB1p+PeRg8ZCZsCA8648IJCZU="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "freesmlauncher.cachix.org-1:Jcp5Q9wiLL+EDv8Mh7c6L9xGk+lXr7/otpKxMOuBuDs="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];

      netrc-file = "/run/secrets/github-netrc";
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;
  };

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets."github-netrc" = {
      path = "/run/secrets/github-netrc";
      mode = "0400";
    };

    secrets."cachix-auth-token" = {
      path = "/run/secrets/cachix-auth-token";
      mode = "0400";
    };
  };

  system.activationScripts.cachixAuthtoken = {
    text = ''
      if [ -f /run/secrets/cachix-auth-token ]; then
        if id -u thibaut >/dev/null 2>&1; then
          mkdir -p /home/thibaut/.config/cachix
          cat /run/secrets/cachix-auth-token | runuser -u thibaut -- ${pkgs.cachix}/bin/cachix authtoken --stdin || true
          chown -R thibaut:users /home/thibaut/.config/cachix
        fi
      fi
    '';
  };
}
