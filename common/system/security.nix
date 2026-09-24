{ ... }:

{
  security.rtkit.enable = true;
  security.polkit.enablePkexecWrapper = true;

  # polkit 127 runs its PAM helper socket-activated and sandboxed with
  # PrivateDevices=yes and DevicePolicy=strict. Howdy needs access to the
  # camera and /dev/uinput from that helper.
  systemd.services."polkit-agent-helper@".serviceConfig = {
    PrivateDevices = false;
    DeviceAllow = [
      "char-rtc r"
      "/dev/null rw"
      "/dev/video2 rw"
      "/dev/uinput rw"
    ];
  };
}
