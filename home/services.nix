{ inputs, config, pkgs, ... }:{

systemd.user.services = {
  openrgb = {
    Unit = {
      Description = "OpenRGB service run by user instead of main user";
    };

    Service = {
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
      ExecStart = "${pkgs.openrgb}/bin/openrgb --server --server-port 6742";
    };
  };
};

}
