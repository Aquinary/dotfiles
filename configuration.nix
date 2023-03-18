# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, file, ... }:

let 
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [ 
      (import "${home-manager}/nixos")
      ./hardware-configuration.nix
    ];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;
 
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  security.polkit.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  programs = { 
    fish.enable = true;
    dconf.enable = true;
  };

  users = {
    defaultUserShell = pkgs.fish;
    users.q = {
      isNormalUser = true;
      description = "q";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    };
  };


  virtualisation.libvirtd.enable = true;
  nixpkgs.config.allowUnfree = true;

  qt5 = {
    enable = true;
    platformTheme = "qt5ct";
  };

  # nixpkgs.overlays = [(self: super: {
  #   vscode = super.vscode.override {
  #     buildInputs = [];
  #   };
  # })];

  environment.systemPackages = with pkgs; [
    dex
    qemu
    gnome.gucharmap
    gnome.gnome-font-viewer
    wget
    material-icons
    git
    nix-output-monitor
    ranger
    gtk3
    gnome.seahorse
    (pkgs.callPackage ./dotfiles/pkgs/caja-extensions { })
    (pkgs.callPackage ./dotfiles/pkgs/vscode { })
    unzip
    unrar
    feh
    neofetch
    #virt-manager
    mate.engrampa
    btop
    lm_sensors
    copyq
    #crow-translate
    sakura
    (vscode.overrideAttrs(old: rec {
      runtimeDependencies = lib.optionals stdenv.isLinux pkexec [ (lib.getLib systemd) fontconfig.lib libdbusmenu wayland ];
    }))
    #tdesktop
    vivaldi
    rofi
    lxappearance
    lua
    sublime4
    #gparted
    #xfce.catfish
    libsForQt5.qtstyleplugin-kvantum
  ];

  
  fonts.fonts = with pkgs; [
    material-icons
  ];
  services = {
    xserver = {
      enable = true;
      windowManager.awesome.enable = true;
      
      displayManager = {  
        defaultSession = "none+awesome";
        autoLogin = {
          enable = true;
          user = "q"; 
         };
      };
    };
    gnome.gnome-keyring.enable = true;
    vnstat.enable = true;
  };

  home-manager.users = {
    root = {
      home.username = "root";
      home.homeDirectory = "/root";
      home.stateVersion = "22.11";
      home = {
        file = {
          ".config/gtk-3.0/settings.ini".source = ./dotfiles/configs/gtk-3.0/settings-dark.ini;
         
          ".config/sakura/sakura.conf".source = ./dotfiles/configs/sakura/sakura.conf;
          ".config/Kvantum".source = ./dotfiles/configs/Kvantum; 
          ".config/qt5ct".source = ./dotfiles/configs/qt5ct;
          ".config/omf".source = ./dotfiles/configs/omf;
          ".config/fish".source = ./dotfiles/configs/fish;
          ".config/dconf".source = ./dotfiles/configs/dconf;

           ".themes/Seventeen-Dark".source = ./dotfiles/themes/Seventeen-Dark;
          ".icons".source = ./dotfiles/icons;

          ".local/share/fonts".source = ./dotfiles/locals/fonts;
          ".local/share/fish".source = ./dotfiles/locals/fish;
          ".local/share/omf".source = ./dotfiles/locals/omf;
        }; 
      };
    };
    q = {config, pkgs, ...}: {
      home.username = "q";
      home.homeDirectory = "/home/q";
      home.stateVersion = "22.11";
      home.packages = with pkgs; [
        mate.mate-polkit
      ];

      programs = {
        home-manager.enable = true;
        git = {
          enable = true;
          userName = "aquinary";
          userEmail = "git@aquinary.ru";
        };
      }; 
      home = {
        file = {
          ".config/awesome".source = ./dotfiles/configs/awesome;

          ".config/gtk-3.0/settings.ini".source = ./dotfiles/configs/gtk-3.0/settings-light.ini;
          ".config/gtk-3.0/colors.css".source = ./dotfiles/configs/gtk-3.0/colors.css;
          ".config/gtk-3.0/gtk.css".source = ./dotfiles/configs/gtk-3.0/gtk.css;

          ".config/sakura/sakura.conf".source = ./dotfiles/configs/sakura/sakura.conf;
          ".config/Kvantum".source = ./dotfiles/configs/Kvantum; 
          ".config/qt5ct".source = ./dotfiles/configs/qt5ct;
          ".config/omf".source = ./dotfiles/configs/omf;
          ".config/fish".source = ./dotfiles/configs/fish;
          ".config/dconf".source = config.lib.file.mkOutOfStoreSymlink ./dotfiles/configs/dconf;
          
          ".themes/Seventeen-Light".source = ./dotfiles/themes/Seventeen-Light;
          ".icons".source = ./dotfiles/icons; 

          ".local/share/fonts".source = ./dotfiles/locals/fonts;
          ".local/share/fish".source = ./dotfiles/locals/fish;
          ".local/share/omf".source = ./dotfiles/locals/omf;
        };
      };
    };    
  };
  system.stateVersion = "22.11"; # Did you read the comment?

}
