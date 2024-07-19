{ pkgs, ... }:{

  services.fwupd.enable = true;
  services.fwupd.extraRemotes = [ "lvfs-testing" ];

}
