{ modulesPath, pkgs, repoSource, ... }:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ./service.nix
  ];

  isoImage.volumeID = "NIXOS_CONFIG_INSTALLER";
  image.fileName = "nixos-config-installer.iso";

  virtualisation.vmVariant = {
    virtualisation.memorySize = 8192;
    virtualisation.cores = 4;
  };

  # Validation continue : toute modification de l'installateur déclenche la recette ISO.
  # Le profil minimal upstream construit une ISO démarrable ; nous ajoutons
  # simplement le dépôt et notre installateur par-dessus.

  # Instantané du dépôt utilisé pour construire cette ISO.
  environment.etc."nixos-config".source = repoSource;

  # Outils nécessaires aux prochaines étapes de l'installateur personnalisé.
  environment.systemPackages = with pkgs; [
    git
    nixos-facter
    parted
    util-linux
  ];
}
