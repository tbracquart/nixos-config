{ pkgs, ... }:

{
  programs = {
    bat.enable = true;
    htop.enable = true;
    kdeconnect.enable = true;

    firefox = {
      enable = true;
      languagePacks = ["fr"];
      policies.Preferences."browser.taskbarTabs.enabled" = { Value = true; Status = "locked"; };
    };
  };

  environment.systemPackages = with pkgs; [
    file
    pciutils
    sops
    ssh-to-age
    usbutils
  ];
}
