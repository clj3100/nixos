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
    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    initrd = {
      systemd.enable = true;
      luks.devices = {
        root = {
          device = "/dev/disk/by-uuid/c97dc33c-f36f-49a9-ace0-e7813f8222ce";
          preLVM = true;
          allowDiscards = true;
          bypassWorkqueues = true;
        };
      };
    };
  };

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

  networking = {
    hostName = "gaming-desktop";
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    hostId = "1e58b0bc";
  };

  environment.systemPackages = with pkgs; [
    git
    acpi
    sbctl
    kwallet-pam
    adwaita-icon-theme
    tpm2-tss
    ddcutil
    i2c-tools
    gamemode
    solaar
    logiops
  ];

  programs = {
    streamdeck-ui = {
      enable = true;
      autoStart = true; # optional
    };
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 10;
        };
        custom = {
          start = "notify-send -a 'Gamemode' 'Optimizations activated'";
          end = "notify-send -a 'Gamemode' 'Optimizations deactivated'";
        };
      };
    };
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    logitech.wireless.enable = true;
    logitech.wireless.enableGraphical = true;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

   services = {
    xserver.enable = true;
    desktopManager = {
      plasma6.enable = true;
    };
    xserver.displayManager = {
      lightdm.enable = true;
      lightdm.greeters.pantheon.enable = true;
    };

    tailscale.enable = true;

    ratbagd.enable = true;

    fstrim.enable = true;

    udev.packages = with pkgs; [
      qmk-udev-rules
      logitech-udev-rules
      #openrgb
    ];
  };  

  security.pam.sshAgentAuth.enable = true;

  # Enabling QMK option configuration
  hardware.keyboard.qmk.enable = true;

  hardware.i2c.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  # OR
   services.pipewire = {
     enable = true;
     pulse.enable = true;
   };

  users.users = {
    trey = {
      createHome = true;
      isNormalUser = true;
      extraGroups = [ "wheel" "input" "video" "networkmanager" "dialout" "plugdev" "tss" "gamemode"];
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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

