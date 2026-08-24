{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    init.defaultBranch = "main";
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [ github-copilot-cli ];
  };
}
