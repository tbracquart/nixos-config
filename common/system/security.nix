{ ... }:

{
  security.rtkit.enable = true;
  security.polkit.enablePkexecWrapper = true;

  # pam_howdy is used by polkit's socket-activated PAM helper.
  # The helper is otherwise sandboxed with a private /dev and cannot open
  # the configured face-recognition camera or create Howdy's input device.
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
