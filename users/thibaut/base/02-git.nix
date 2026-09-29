{ myConfig, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = myConfig.fullName;
        email = myConfig.email;
      };
      init.defaultBranch = "main";
      pull = {
        rebase = true;
      };
    };
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [ github-copilot-cli ];
  };
}
