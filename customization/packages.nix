{pkgs, ...}:{

services.tailscale.enable = true;
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};
#programs.kdeconnect = {
#  enable = true;
#  #package = pkgs.kdePackages.kdeconnect-kde;
#};
}
