{ pkgs, ... }:

{
  users.users.thibaut = {
    isNormalUser = true;
    description = "Thibaut Bracquart";
    extraGroups = [ "networkmanager" "wheel" "uinput" ];
    shell = pkgs.fish;
  };
}
