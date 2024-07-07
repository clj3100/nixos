{ pkgs, ... }:{
  services.syncoid = {
      enable = true;
      #user = "backupuser";
      commonArgs = ["--no-sync-snap" "--no-privilege-elevation"];
      sshKey = "/var/lib/syncoid/backup";
      commands."truenas_home" = {
        source = "rpool/home";
        target = "n16backup@192.168.1.8:First/Backup/nixos16/home";
      };
      commands."truenas_root" = {
        source = "rpool/root";
        target = "n16backup@192.168.1.8:First/Backup/nixos16/root";
      };
      commands."truenas_vms" = {
        source = "rpool/vms";
        target = "n16backup@192.168.1.8:First/Backup/nixos16/vms";
      };
  };
}
