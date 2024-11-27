# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../customization
    ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    #kernelPackages = pkgs.linuxPackages_latest;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      systemd.enable = true;
      luks.devices = {
        root = {
          device = "/dev/disk/by-uuid/441ed4f3-6c00-4ba0-aaae-2336300d5b80";
          preLVM = true;
          allowDiscards = true;
          bypassWorkqueues = true;
        };
      };
    };
    blacklistedKernelModules = [ "k10temp" ];
    kernelModules = [ "acpi_call" "zenpower" "tpm_crb" ];
    kernelParams = [ "amd_pstate=active" "amdgpu.sg_display=0" ];
    extraModulePackages = with config.boot.kernelPackages;
      [
        acpi_call
        cpupower
        zenpower
      ]
      ++ [pkgs.cpupower-gui];
     zfs.forceImportRoot = false;
  };

  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.allowed-users = [ "trey" ];

    # Enabling auto optimize on rebuild https://nixos.wiki/wiki/Storage_optimization
    settings.auto-optimise-store = true;

    # Enabling weekly garbage collection https://nixos-and-flakes.thiscute.world/nixos-with-flakes/other-useful-tips#reducing-disk-usage
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/5a1d6eb2-34be-4e4a-bd8b-2375f82e5325";
  }];

  time.timeZone = "America/New_York";

  networking = {
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    hostName = "desktoparm"; 
    hostId = "1e58b0bc";
    firewall = {
      allowedTCPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];  
      allowedUDPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];  
    };
  };

  environment.systemPackages = with pkgs; [
    git
    zfs
    acpi
    cpupower-gui
    kwallet-pam
    adwaita-icon-theme
    tpm2-tss
    barrier
  ];

  security.protectKernelImage = false;
  programs.dconf.enable = true;

  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  services = {
    xserver.enable = true;
    desktopManager = {
      plasma6.enable = true;
    };
    xserver.displayManager = {
      lightdm.enable = true;
      lightdm.greeters.pantheon.enable = true;
    };
    zfs.autoScrub = {
      enable = true;
      interval = "*-*-1,15 02:30";
    };

    tailscale.enable = true;

    fstrim.enable = true;
    
    openssh = {
      enable = true;
      settings.AllowUsers = [ "trey" ];
    };

    udev.packages = with pkgs; [
      qmk-udev-rules
      openrgb
    ];
  };
  
  security.pam.sshAgentAuth.enable = true;

  security.pam.services = {
    login.kwallet.enable = true;
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enabling QMK option configuration
  hardware.keyboard.qmk.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  # OR
   services.pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
   };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    trey = {
      isNormalUser = true;
      extraGroups = [ "wheel" "input" "video" "networkmanager" "dialout" "plugdev" "tss"];
    };
    backupuser = {
      isSystemUser = true;
      group = "backupuser";
      createHome = true;
      home = "/var/lib/syncoid";
    };
  };

  users.groups.backupuser = {};

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

