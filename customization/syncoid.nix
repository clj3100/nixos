{ pkgs, ... }:{
  systemd.services = {
    syncoid-nas = {
      description = "Syncoid backup to home TrueNAS";
      #after = [ "sanoid.service" "network-online.target" ];
      #wantedBy = [ "sanoid.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.sanoid}/bin/syncoid --no-privilege-elevation --no-sync-snap --sshkey /var/lib/syncoid/backup rpool/home n16backup@192.168.1.8:First/Backup/nixos16";
        User = "backupuser";
      };
      path = [ pkgs.openssh pkgs.sanoid pkgs.zfs ];
    };
  };
}
