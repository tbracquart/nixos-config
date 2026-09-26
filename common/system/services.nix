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

    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="a291", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="df11", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="a51a", TAG+="uaccess"
    '';

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
