# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../customization
      ./nixos-hardware
      ./backups.nix
    ];

  boot = {
    supportedFilesystems = [ "btrfs" "ntfs" ];
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

  fonts.packages = [
    pkgs.nerd-fonts._0xproto
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.nerd-fonts.hack
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.allowed-users = [ "trey" ];

    # Enabling auto optimize on rebuild https://nixos.wiki/wiki/Storage_optimization
    settings.auto-optimise-store = true;

    # Enabling weekly garbage collection https://nixos-and-flakes.thiscute.world/nixos-with-flakes/other-useful-tips#reducing-disk-usage
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  networking = {
    hostName = "gaming-desktop";
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    hostId = "1e58b0bc";
    firewall = {
      allowedTCPPorts = [ 59999 24800 22000 ]; # Opening ports for MoonDeckBuddy, input-leap, and Syncthing
      allowedUDPPorts = [ 22000 21027 ]; # Ports for Syncthing
      allowedTCPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];  
      allowedUDPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];  
    };
    interfaces.enp8s0 = {
      wakeOnLan.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    acpi
    sbctl
    kdePackages.kwallet-pam
    adwaita-icon-theme
    tpm2-tss
    ddcutil
    i2c-tools
    gamemode
    libratbag
    piper
    logiops
    streamcontroller
    nvtopPackages.full
    btrfs-assistant
    vulkan-tools
  ];

  programs = {
    partition-manager.enable = true;
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 10;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };

  hardware = {
    bluetooth.enable = true;
    graphics ={ 
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [mangohud ];
      extraPackages32 = with pkgs; [mangohud];
    };
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };
    logitech.wireless.enable = true;
    logitech.wireless.enableGraphical = true;

    # Enabling QMK option configuration
    keyboard.qmk.enable = true;

    # Driver for xbox wireless controller
    xpadneo.enable = true;

    i2c.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

   services = {
    fwupd.enable = true;
    flatpak.enable = true;
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };
    desktopManager = {
      plasma6.enable = true;
    };
    xserver.displayManager = {
      lightdm.enable = true;
      lightdm.greeters.slick.enable = true;
    };

    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };

    tailscale.enable = true;

    ratbagd.enable = true;

    fstrim.enable = true;
    
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber.enable = true;
      extraConfig.pipewire."91-null-sinks" = {
        "context.objects" = [
          {
            # A default dummy driver. This handles nodes marked with the "node.always-driver"
            # properyty when no other driver is currently active. JACK clients need this.
            factory = "spa-node-factory";
            args = {
              "factory.name"     = "support.node.driver";
              "node.name"        = "Dummy-Driver";
              "priority.driver"  = 8000;
            };
          }
          {
            factory = "adapter";
            args = {
              "factory.name"     = "support.null-audio-sink";
              "node.name"        = "Microphone-Proxy";
              "node.description" = "Microphone";
              "media.class"      = "Audio/Source/Virtual";
              "audio.position"   = "MONO";
            };
          }
          {
            factory = "adapter";
            args = {
              "factory.name"     = "support.null-audio-sink";
              "node.name"        = "Desktop-Output-Proxy";
              "node.description" = "Desktop Output";
              "media.class"      = "Audio/Sink";
              "audio.position"   = "FL,FR";
            };
          }
          {
            factory = "adapter";
            args = {
              "factory.name"     = "support.null-audio-sink";
              "node.name"        = "Music-Output-Proxy";
              "node.description" = "Music Output";
              "media.class"      = "Audio/Sink";
              "audio.position"   = "FL,FR";
            };
          }
        ];
      };
    };

    udev.packages = with pkgs; [
      qmk-udev-rules
      logitech-udev-rules
    ];
  };  

  security.pam.sshAgentAuth.enable = true;

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

