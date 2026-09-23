{ pkgs, ... }:

{
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = { enable = true; addresses = true; };
    };

    fwupd.enable = true;
    gvfs.enable = true;
    openssh.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
  };

  # fwupd-refresh can be triggered by its timer while a NixOS activation is
  # still starting polkit. fwupdmgr refresh requires the PolicyKit daemon.
  systemd.services.fwupd-refresh = {
    wants = [ "polkit.service" ];
    after = [ "polkit.service" ];
  };
}
