{ config, pkgs, ... }:

{
  home.file.".local/state/noctalia/settings.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.my.flakePath}/users/thibaut/dotfiles/noctalia-settings.toml";

  home.file.".config/hypr/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.my.flakePath}/users/thibaut/dotfiles/hyprland.lua";

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd.enable = true;
    extraConfig = ''require("init")'';
  };

  systemd.user.services.hyprland-power-inhibit = {
    Unit = {
      Description = "Inhibit logind power key handling for Hyprland session";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.systemd}/bin/systemd-inhibit --what=handle-power-key --who=Hyprland --why=\"Noctalia power menu\" --mode=block sleep infinity";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
