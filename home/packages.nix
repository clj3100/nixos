{inputs, pkgs, ... }:
{

  home.packages = with pkgs; [
  firefox-wayland
  vim
  zip

  jq
  mtr
  iperf3  

  file
  which
  tree
  btop
  iotop
  iftop
  strace
  lsof

  sysstat
  lm_sensors
  ethtool
  pciutils
  usbutils

  protonmail-desktop
  protonvpn-cli
  protonvpn-gui
  
  tailscale
  trayscale

  age                               # for my secrets
  awscli2
    dmidecode
    entr                              # perform action when file change
    fd                                # find replacement
    file                              # Show file information 
    fzf                               # fuzzy finder
    gh                                # github cli
    gtt                               # google translate TUI
    gtrash                            # rm replacement, put deleted files in system trash
    hexdump
    inxi                              # system info
    killall                           # to kill our little friends
    lazygit
    lshw
    nitch                             # systhem fetch util
    nix-prefetch-github
    pciutils
    tldr                              # user-friendly help

    # C / C++
    gcc
    gnumake

    bleachbit                         # cache cleaner
    ffmpeg
    libnotify
    man-pages                         # extra man pages
    ncdu                              # disk space
    sublime
    openssl
    pamixer                           # pulseaudio command line mixer
    pavucontrol                       # pulseaudio volume controle (GUI)
    playerctl                         # controller for media players
    poweralertd
    unzip
    wget
    krunner-pass
    krunner-ssh
    krunner-symbols
    discord
    via
    qmk
    qmk_hid
    qmk-udev-rules
    vlc
    floorp
    prusa-slicer
    bottles
    dnsutils
    nmap
    ipcalc
    tpm2-tools
    tpm2-pkcs11
    ksshaskpass
    openrgb
    cheese
    appimage-run
    spectacle
    wlx-overlay-s
    vscode
  ];

}
