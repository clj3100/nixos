{ inputs, config, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./services.nix
  ]; 

  home.username = "trey";
  home.homeDirectory = "/home/trey";

  programs.git = {
    enable = true;
    userName = "Craig Jones";
    userEmail = "clj3100@pm.me";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  services.kdeconnect = {
   enable = true;
   package = pkgs.kdePackages.kdeconnect-kde;
   indicator = true;
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  home.shellAliases = {

  nixedit = "vi /home/trey/nixos-config";
  homedit = "vi /home/trey/nixos-config/home";
  g = "git";
  nixrebuild = "sudo nixos-rebuild";
  nixupdate = "nix flake update /home/trey/nixos-config";
  };

  services.fusuma.enable = true;
  services.fusuma.settings = {
    threshold = {
      swipe = 0.1;
    };
    interval = {
      swipe = 0.7;
    };
    swipe = {
      "3" = {
        up = {
          sendkey = "LEFTMETA+W";
        };
        down = {
          sendkey = "LEFTMETA+W";
        };
      };
    };
  };
  services.fusuma.extraPackages = with pkgs; [ coreutils-full ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

}
