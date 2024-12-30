{inputs, pkgs, ... }:
{

    home.packages = with pkgs; [
    
    # Browsers
    firefox-wayland
    floorp
    ungoogled-chromium

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
    f3
    goverlay
    easyeffects
    remmina
    protonup-qt
    qpwgraph
    tio # Serial io device tool
    nexusmods-app-unfree
    lutris

    # Steamtinkerlaunch dependencies
    yad
    xdotool
    xorg.xwininfo
    wine
    winetricks
  ];

}
