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
    datasets."rpool/home" = {
      useTemplate = [ "backup" ];
    };
  };
}
