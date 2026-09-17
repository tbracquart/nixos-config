{ inputs, pkgs, ... }:

let
  sopsPkgs = pkgs // {
    buildGo125Module = pkgs.buildGoModule;
  };
in
{
  sops.package = (import inputs.sops-nix { pkgs = sopsPkgs; }).sops-install-secrets;
}
