{ pkgs, inputs, ... }:

let
  textMimeTypes = [
    "text/plain"
    "text/markdown"
    "text/x-nix"
    "text/x-shellscript"
    "text/x-python"
    "text/x-csrc"
    "text/x-c++src"
    "text/x-rust"
    "text/css"
    "text/csv"
    "application/json"
    "application/xml"
    "text/xml"
    "application/toml"
    "application/yaml"
  ];
in
{
  home.packages = (with pkgs; [
    alacritty
    btop
    cachix
    celluloid
    fastfetch
    freefilesync
    fresh-editor
    gimp
    libreoffice
    nemo-with-extensions
    netflix
    peazip
    ripgrep
    tree
    udiskie
    ytmdesktop
  ]) ++ [
    inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.omnibin.packages.${pkgs.stdenv.hostPlatform.system}.omnibin-shell
    inputs.multiverse.packages.${pkgs.stdenv.hostPlatform.system}.mvs
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  # Les éditeurs en terminal doivent être lancés dans un vrai terminal
  # lorsqu'ils sont ouverts depuis Nemo ou un autre explorateur de fichiers.
  xdg.desktopEntries.helix = {
    name = "Helix";
    genericName = "Éditeur de texte";
    comment = "Ouvrir des fichiers avec Helix dans Alacritty";
    exec = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.helix}/bin/hx %F";
    terminal = false;
    type = "Application";
    categories = [ "Development" "TextEditor" "Utility" ];
    mimeType = textMimeTypes;
  };

  xdg.desktopEntries."fresh-editor" = {
    name = "Fresh Editor";
    genericName = "Éditeur de texte";
    comment = "Ouvrir des fichiers avec Fresh dans Alacritty";
    exec = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.fresh-editor}/bin/fresh %F";
    terminal = false;
    type = "Application";
    categories = [ "Development" "TextEditor" "Utility" ];
    mimeType = textMimeTypes;
  };

  # Les associations MIME sont déclarées dans la configuration et gérées
  # par Home Manager, plutôt que modifiées impérativement à l'activation.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = builtins.listToAttrs (map (mimeType: {
      name = mimeType;
      value = [ "helix.desktop" ];
    }) textMimeTypes);
  };
}
