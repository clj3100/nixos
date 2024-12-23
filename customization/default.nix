{
  nix.settings.experimental-features = "nix-command flakes";

  imports = [ 
    ./packages.nix
    ./common.nix
    ./virtualization.nix
    # ./sanoid.nix
#    ./syncoid.nix
  ];

}
