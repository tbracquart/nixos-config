# Correctif temporaire pour Omnibin.
#
# À supprimer lorsque fzakaria/omnibin intégrera pkgs.sqlite dans les
# buildInputs de son paquet. Cette expression reprend nix/omnibin.nix en
# ne modifiant que cette dépendance de compilation.
{
  pkgs,
  database ? null,
}:
let
  inherit (pkgs) lib;

  unwrapped = pkgs.rustPlatform.buildRustPackage {
    pname = "omnibin";
    version = "0.1.0";

    src = lib.fileset.toSource {
      root = ../.;
      fileset = lib.fileset.unions [
        ../Cargo.toml
        ../Cargo.lock
        ../src
      ];
    };
    cargoLock.lockFile = ../Cargo.lock;

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [
      pkgs.fuse3
      pkgs.sqlite
    ];

    meta = {
      description = "Every binary nixpkgs ever shipped, on your PATH";
      mainProgram = "omnibin";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };

  runtimeTools = [
    pkgs.zstd
    pkgs.xz
    pkgs.bzip2
    pkgs.brotli
    pkgs.fuse3
  ];
in
pkgs.runCommand "omnibin"
  {
    nativeBuildInputs = [ pkgs.makeWrapper ];
    inherit (unwrapped) meta;
  }
  ''
    mkdir -p $out/bin
    makeWrapper ${unwrapped}/bin/omnibin $out/bin/omnibin \\
      --prefix PATH : ${lib.makeBinPath runtimeTools} \\
      ${lib.optionalString (database != null) "--set-default OMNIBIN_DB ${database}"}
  ''
