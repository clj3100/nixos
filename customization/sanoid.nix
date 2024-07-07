{
  services.sanoid = {
    enable = true;
    templates.backup = {
      autoprune = true;
      autosnap = true;
      hourly = 24;
      daily = 30;
      monthly = 1;
    };
    templates.lessbackup = {
      autoprune = true;
      autosnap = true;
      hourly = 0;
      daily = 7;
      monthly = 1;
    };
    datasets."rpool/home" = {
      useTemplate = [ "backup" ];
    };
    
    datasets."rpool/root" = {
      useTemplate = [ "lessbackup" ];
    };

    datasets."rpool/vms" = {
      useTemplate = [ "lessbackup" ];
    };
  };
}
