# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./framework16.nix
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
          device = "/dev/disk/by-uuid/f4dea94c-906a-4b7a-b31e-a8ead03b6060";
          preLVM = true;
          allowDiscards = true;
          bypassWorkqueues = true;
        };
      };
    };
    blacklistedKernelModules = [ "k10temp" ];
    kernelModules = [ "acpi_call" "cros_ec" "cros_ec_lpcs" "zenpower" "tpm_crb" "i2c-dev" "i2c-piix4" ];
    kernelParams = [ "amd_pstate=active" "amdgpu.sg_display=0" ];
    extraModulePackages = with config.boot.kernelPackages;
      [
        acpi_call
        cpupower
        framework-laptop-kmod
        zenpower
      ]
      ++ [pkgs.cpupower-gui];
     zfs.forceImportRoot = false;
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

  time.timeZone = "America/New_York";

  networking = {
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    hostName = "nixos16"; 
    hostId = "1e58b0bb";
    firewall = {
      allowedTCPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];  
      allowedUDPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];  
    };
  };

  environment.etc = {
    "libinput/local-overrides.quirks".text = ''
      [Keyboard]
      MatchUdevType=keyboard
      MatchName=Framework Laptop 16 Keyboard Module - ANSI Keyboard
      AttrKeyboardIntegration=internal
    '';
  };

  environment.systemPackages = with pkgs; [
    git
    zfs
    acpi
    brightnessctl
    cpupower-gui
    framework-tool
    powertop
    fw-ectool
    kdePackages.frameworkintegration
    wluma
    kdePackages.kwallet-pam
    adwaita-icon-theme
    iio-sensor-proxy
    tpm2-tss
    ddcutil
    i2c-tools
    gamemode
  ];

  security.protectKernelImage = false;
  programs.dconf.enable = true;

  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.type = "simple";
  };
 
  systemd.user.units.wluma.wantedBy = [ "default.target"];

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

  services = {
    flatpak.enable = true;
    fwupd.enable = true;
    xserver.enable = true;
    desktopManager = {
      plasma6.enable = true;
    };
    xserver.displayManager = {
      lightdm.enable = true;
      lightdm.greeters.slick.enable = true;
    };

    zfs.autoScrub = {
      enable = true;
      interval = "*-*-1,15 02:30";
    };

    tailscale.enable = true;
    
    power-profiles-daemon.enable = true;

    fstrim.enable = true;

    fprintd.enable = true;
 
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
    };

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };
    udev.packages = with pkgs; [
      qmk-udev-rules
      wluma
    ];
  };
  
  security.pam.sshAgentAuth.enable = true;

  security.pam.services = {
    kde.fprintAuth = true;
    login.fprintAuth = true;
    login.kwallet.enable = true;
  };

  hardware = {
    # Enabling QMK option configuration
    keyboard.qmk.enable = true;

    i2c.enable = true;

    bluetooth.enable = true;
    graphics ={ 
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [mangohud ];
      extraPackages32 = with pkgs; [mangohud];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    trey = {
      isNormalUser = true;
      extraGroups = [ "wheel" "input" "video" "networkmanager" "dialout" "plugdev" "tss" "gamemode"];
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

