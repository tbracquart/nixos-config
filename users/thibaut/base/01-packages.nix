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

  helixWithDockAppId = pkgs.helix.overrideAttrs (old: {
    buildCommand = (old.buildCommand or "") + ''
      desktop="$out/share/applications/Helix.desktop"
      cp "$desktop" "$TMPDIR/Helix.desktop"
      grep -q '^Terminal=true$' "$TMPDIR/Helix.desktop"
      sed -i 's/^Terminal=true$/Terminal=false/' "$TMPDIR/Helix.desktop"
      substituteInPlace "$TMPDIR/Helix.desktop" \
        --replace-fail "Exec=hx %F" \
        "Exec=${pkgs.alacritty}/bin/alacritty --class Helix -e hx %F"
      if ! grep -q '^StartupWMClass=' "$TMPDIR/Helix.desktop"; then
        grep -q '^Type=Application$' "$TMPDIR/Helix.desktop"
        sed -i '/^Type=Application$/a StartupWMClass=Helix' "$TMPDIR/Helix.desktop"
      fi
      cp --remove-destination "$TMPDIR/Helix.desktop" "$desktop"
    '';
  });
in
{
  home.packages = (with pkgs; [
    alacritty
    btop
    cachix
    celluloid
    fastfetch
    freefilesync
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
    pkgs.fresh-editor
    inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.omnibin.packages.${pkgs.stdenv.hostPlatform.system}.omnibin-shell
    inputs.multiverse.packages.${pkgs.stdenv.hostPlatform.system}.mvs
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = helixWithDockAppId;
  };

  # Fresh utilise directement son icône officielle depuis ses sources.
  xdg.desktopEntries."fresh-editor" = {
    name = "Fresh Editor";
    genericName = "Éditeur de texte";
    comment = "Ouvrir des fichiers avec Fresh dans Alacritty";
    exec = "${pkgs.alacritty}/bin/alacritty --class Fresh -e ${pkgs.fresh-editor}/bin/fresh %F";
    icon = "${pkgs.fresh-editor.src}/docs/icons/linux/hicolor/256x256/apps/fresh.png";
    terminal = false;
    type = "Application";
    settings.StartupWMClass = "Fresh";
    categories = [ "Development" "TextEditor" "Utility" ];
    mimeType = textMimeTypes;
  };

  # Les associations MIME sont déclarées dans la configuration et gérées
  # par Home Manager, plutôt que modifiées impérativement à l'activation.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = builtins.listToAttrs (map (mimeType: {
      name = mimeType;
      value = [ "Helix.desktop" ];
    }) textMimeTypes);
  };
}
