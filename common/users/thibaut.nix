{ myConfig, pkgs, ... }:

{
  users.users.${myConfig.username} = {
    isNormalUser = true;
    description = myConfig.fullName;
    extraGroups = [ "networkmanager" "wheel" "uinput" ];
    shell = pkgs.fish;
  };
}
