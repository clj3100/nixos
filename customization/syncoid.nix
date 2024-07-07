{ pkgs, ... }:{
  services.syncoid = {
      enable = true;
      #user = "backupuser";
      commonArgs = ["--no-sync-snap" "--no-privilege-elevation"];
      sshKey = "/var/lib/syncoid/backup";
      commands."truenas" = {
        source = "rpool/home";
        target = "n16backup@192.168.1.8:First/Backup/nixos16/home";
      };
  };
}
