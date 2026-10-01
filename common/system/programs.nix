{ ... }:

{
  programs = {
    bat.enable = true;
    htop.enable = true;
    kdeconnect.enable = true;

    firefox = {
      languagePacks = [ "fr" ];
    };

  };
}
