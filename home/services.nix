{ inputs, config, pkgs, ... }:{

systemd.user.services = {
  openrgb = {
    Unit = {
      Description = "OpenRGB service run by user instead of main user";
    };

    Service = {
      Type = "simple";
      Restart = "always";
      RestartSec = "5";
      ExecStart = "${pkgs.appimage-run}/bin/appimage-run /home/trey/Documents/OpenRGB-x86_64.AppImage --startminimized";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
};

}
