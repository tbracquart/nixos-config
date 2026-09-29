{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Thibaut Bracquart";
        email = "202062783+tbracquart@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      pull = {
        rebase = false;
      };
    };
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [ github-copilot-cli ];
  };
}
