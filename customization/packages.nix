{pkgs, ...}:{

programs = {
  steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    protontricks.enable = true;
  };
  appimage.binfmt = true;
  ssh.startAgent = true;
};

security = {
  tpm2 = {
    enable = true;
    pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
    tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  };  
};

services = {
    syncthing = {
        enable = true;
        group = "users";
        user = "trey";
        dataDir = "/home/trey/Documents";    # Default folder for new synced folders
        configDir = "/home/trey/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
};

}
