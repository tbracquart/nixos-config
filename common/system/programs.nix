{ ... }:

{
  programs = {
    bat.enable = true;
    htop.enable = true;
    kdeconnect.enable = true;

    firefox = {
      enable = true;
      languagePacks = [ "fr" ];
    };

  };
}
