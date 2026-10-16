{ pkgs, ... }:

{
  boot = {
    loader = {
      limine = {
        enable = true;
        maxGenerations = 20;
        style = {
          wallpapers = [
            (pkgs.fetchurl {
              name = "nix-wallpaper.png";
              url = "https://wallpaperaccess.com/full/23970580.jpg";
              hash = "sha256-5DcL/eP6BYg8NIhVDxrgRiyt4EYd5dg6bBShzpYqUWE=";
            })
          ];
          wallpaperStyle = "stretched";
        };
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };

    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "i915.force_probe=!9a49"
      "xe.force_probe=9a49"
      "loglevel=3"
      "rd.systemd.show_status=false"
    ];
    consoleLogLevel = 3;

    resumeDevice = "/dev/mapper/luks-a0f369c9-319a-4e22-ac5f-7b5a191b22e8";

    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    initrd = {
      kernelModules = [ "xe" ];
      systemd.enable = true;
      verbose = false;
      luks.devices."luks-a0f369c9-319a-4e22-ac5f-7b5a191b22e8".device =
        "/dev/disk/by-uuid/a0f369c9-319a-4e22-ac5f-7b5a191b22e8";
    };
  };
}
