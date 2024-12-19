# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usbhid" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a4dadf8f-c9f7-4039-95fc-4d9ae0ac25e8";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd:1" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/a4dadf8f-c9f7-4039-95fc-4d9ae0ac25e8";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd:1" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/a4dadf8f-c9f7-4039-95fc-4d9ae0ac25e8";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd:1" "noatime" ];
    };

  fileSystems."/etc" =
    { device = "/dev/disk/by-uuid/a4dadf8f-c9f7-4039-95fc-4d9ae0ac25e8";
      fsType = "btrfs";
      options = [ "subvol=etc" "compress=zstd:1" "noatime" ];
    };
  
  fileSystems."/vms" =
    { device = "/dev/disk/by-uuid/a4dadf8f-c9f7-4039-95fc-4d9ae0ac25e8";
      fsType = "btrfs";
      options = [ "subvol=vms" "compress=zstd:1" "noatime" ];
    };
  
  fileSystems."/home/trey/games" =
    { device = "/dev/disk/by-uuid/a4dadf8f-c9f7-4039-95fc-4d9ae0ac25e8";
      fsType = "btrfs";
      options = [ "subvol=games" "compress=zstd:1" "noatime" ];
    };
  
  fileSystems."/home/trey/games1" =
    { device = "/dev/disk/by-uuid/3CF84D82F84D3B80";
      fsType = "ntfs-3g"; 
      options = [ "rw" "uid=1000" "gid=100" "nosuid" "nodev" "relatime"];
    };

  fileSystems."/home/trey/games2" =
    { device = "/dev/disk/by-uuid/084C36964C367F0E";
      fsType = "ntfs-3g"; 
      options = [ "rw" "uid=1000" "gid=100" "nosuid" "nodev" "relatime"];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D630-08C1";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/4fa8ead5-1060-4c9b-916b-0fc01f39a2ea"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp8s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp7s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
