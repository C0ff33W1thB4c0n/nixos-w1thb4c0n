# eDIt this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  #############
  #  [BOOT]   #
  #############

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.kernel.sysctl = { "vm.max_map_count" = 1048576; };

  ###################
  #  [NETWORKING]   #
  ###################

  networking.hostName = "b4c0nr3s34rch"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  ############### 
  #  [LAYOUT]   #
  ###############

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  ############ 
  #  [X11]   #
  ############


  # Enable the X11 windowing system.
  services.xserver = {
	  enable = true;
	  videoDrivers = [ "nvidia" ];
	  autorun = true;
	  layout = "us";
	  xkbOptions = "eurosign:e";
	  displayManager.defaultSession = "none+bspwm";
	  windowManager.bspwm.enable = true;
	  windowManager.bspwm.configFile = "/home/c0ff33/.config/bspwm/bspwmrc";
	  windowManager.bspwm.sxhkd.configFile = "/home/c0ff33/.config/sxhkd/sxhkdrc";
  };

  #################
  #  [SERVICES]   #
  #################

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
   services.printing.enable = true;

   services.udev.packages = [ pkgs.yubikey-personalization ];

  # GVFS
    services.gvfs = {
      enable = true;
    };
  # Enable sound.
   sound.enable = true;
   hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  ##############
  #  [USERS]   #
  ##############
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.c0ff33 = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" "libvirtd" ]; # Enable ‘sudo’ for the user.
   };

  #################
  #  [PACKAGES]   #
  #################

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.allowed-users = [ "c0ff33" ];

  nixpkgs.config.allowUnfree = true;  
  nixpkgs.config.permittedInsecurePackages = [
    "electron-12.2.3"
    "electron-25.9.0"
    "electron-19.1.9"
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {}
      "c0ff33" = import ./home.nix;
    ;
  };


  environment.systemPackages = with pkgs; [

  # System umgebung
    sxhkd
    nitrogen
    polybar
    dmenu
    pavucontrol
    xdg-user-dirs
    gtk-engine-murrine
    gruvbox-dark-gtk
    gruvbox-dark-icons-gtk
    alacritty
    picom
    rofi
    arandr
    redshift
    gutenprint
    samba
    ntfs3g
    smartmontool
    gvfs
    fuse
    home-manager

  # System tools
    vim
    wget
    git
    gcc
    cmake
    unzip
    firefox
    xfce.thunar
    ranger

  # gaming
    minecraft
    prismlauncher
    discord
    wine
    mangohud
    lutris
    (lutris.override {
      extraPkgs = pkgs: [
        wineWowPackages.stable
        winetricks
      ];
    })
    steam

  # hacking etc
    netdiscover
    nmap
    john

  # multimedia
    spotify
    spicetify-cli
    fzf
    mpv
    vlc

  # dev
    jdk17
    vscode
    texlive.combined.scheme-full
    vimPlugins.vimtex
    etcher
    docker

  # study
    zathura 
    libreoffice
    thunderbird-unwrapped
    obsidian
    gimp
    krita
    inkscape
    calcurse
    xournalpp
    html-xml-utils

  # security
    yubikey-manager-qt
    yubico-pam
    libyubikey
    pam_u2f
    keepassxc

  ];

  programs.dconf.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  #######################
  #  [VIRTUALISATION]   #
  #######################

  virtualisation = {
    docker.enable = true;
  };
  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
   system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
