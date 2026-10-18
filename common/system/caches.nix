{ myConfig }:

let
  publicCaches = [
    {
      substituter = "https://nix-community.cachix.org";
      publicKey = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    }
    # {
    #   substituter = "https://attic.xuyh0120.win/lantian";
    #   publicKey = "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=";
    # }
    {
      substituter = "https://freesmlauncher.cachix.org";
      publicKey = "freesmlauncher.cachix.org-1:Jcp5Q9wiLL+EDv8Mh7c6L9xGk+lXr7/otpKxMOuBuDs=";
    }
    {
      substituter = "https://noctalia.cachix.org";
      publicKey = "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=";
    }
  ];

  personalCaches =
    if myConfig.cachix.enable then [
      {
        substituter = "https://${myConfig.cachix.name}.cachix.org";
        publicKey = "${myConfig.cachix.name}.cachix.org-1:${myConfig.cachix.publicKey}";
      }
    ] else [];

  caches = personalCaches ++ publicCaches;
in
{
  substituters = map (cache: cache.substituter) caches;
  trusted-public-keys = map (cache: cache.publicKey) caches;
}
