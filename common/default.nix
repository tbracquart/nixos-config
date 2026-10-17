{ inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.nix-openclaw.overlays.default
    (final: prev: {
      openclawRuntimePlugins = prev.openclawRuntimePlugins // {
        # nix-openclaw 08732c0 packages Codex with ./dist/index.js, but
        # leaves package.json pointing at the unpublished ./index.ts entry.
        # Patch the manifest in installPhase so the correction runs after
        # the custom runtime-plugin installer has populated $out.
        codex = prev.openclawRuntimePlugins.codex.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.jq ];
          installPhase = (old.installPhase or "") + "\n" + ''
            ${final.jq}/bin/jq '.openclaw.extensions = ["./dist/index.js"]' "$out/package.json" > "$out/package.json.tmp"
            mv "$out/package.json.tmp" "$out/package.json"
          '';
        });
      };
    })
  ];

  imports = [
    ./system/locale.nix
    ./system/networking.nix
    ./system/nix.nix
    ./system/packages.nix
    ./system/programs.nix
    ./system/security.nix
    ./system/services.nix
    ./system/shell.nix
    ./users/thibaut.nix
    ../modules
    ../profiles
    inputs.home-manager.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];
}
