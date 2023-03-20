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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
 
  networking.hostName = "yoshinon"; # Define your hostname.

  security.polkit.enable = true;

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
    users.aquinary = {
      isNormalUser = true;
      description = "aquinary";
      extraGroups = [ "networkmanager" "wheel" "storage" "audio" "libvirtd" ];
    };
    groups.libvirtd.members = [ "root" "aquinary"];
  };


  virtualisation = {
    libvirtd = { 
      enable = true;
      qemu.verbatimConfig = ''
        user = "aquinary"
        nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
      '';
    };

    docker = {
      enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  qt5 = {
    enable = true;
    platformTheme = "qt5ct";
  };

  environment.systemPackages = with pkgs; [
    dex
    ntfs3g
    smem
    qemu
    OVMF
    gnome.gucharmap
    ncdu
    volctl
    wget
    material-icons
    git
    pavucontrol
    ranger
    discord
    jetbrains.webstorm
    openh264
    gnome.seahorse
    (pkgs.callPackage ./pkgs/caja-extensions { })
    unzip
    unrar
    input-remapper
    feh
    neofetch
    virt-manager
    mate.engrampa
    btop
    killall
    lm_sensors
    copyq
    calc
    crow-translate
    sakura
    vscode
    pciutils
    tdesktop
    haruna
    vivaldi
    rofi
    lxappearance
    lua
    sublime4
    gparted
    xfce.catfish
    docker-compose
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
          user = "aquinary"; 
         };
      };

      
      libinput = {
        enable = true; 
        mouse.leftHanded = true;
      };

      
    };

    picom = {
      enable = true;
      vSync = true;
      fade = true;
      fadeSteps = [0.01 0.01];
      fadeDelta = 2;
    };

    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
 
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
          ".config/gtk-3.0/settings.ini".source = ./configs/gtk-3.0/settings-dark.ini;
          ".config/gtk-3.0/colors.css".source = ./configs/gtk-3.0/colors.css;
          ".config/gtk-3.0/gtk.css".source = ./configs/gtk-3.0/gtk.css;

          ".config/sakura/sakura.conf".source = ./configs/sakura/sakura.conf;
          ".config/Kvantum".source = ./configs/Kvantum; 
          ".config/qt5ct".source = ./configs/qt5ct;
          ".config/omf".source = ./configs/omf;
          ".config/fish".source = ./configs/fish;
          ".config/dconf".source = ./configs/dconf;

          ".themes/Seventeen-Dark".source = ./themes/Seventeen-Dark;
          ".icons".source = ./icons;

          ".local/share/fonts".source = ./locals/fonts;
          ".local/share/fish".source = ./locals/fish;
          ".local/share/omf".source = ./locals/omf;
        }; 
      };
    };
    aquinary = {config, pkgs, ...}: {
      home.username = "aquinary";
      home.homeDirectory = "/home/aquinary";
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
          ".config/awesome".source = config.lib.file.mkOutOfStoreSymlink ./configs/awesome;

          ".config/gtk-3.0/settings.ini".source = ./configs/gtk-3.0/settings-light.ini;
          ".config/gtk-3.0/colors.css".source = ./configs/gtk-3.0/colors.css;
          ".config/gtk-3.0/gtk.css".source = ./configs/gtk-3.0/gtk.css;

          ".config/sakura/sakura.conf".source = ./configs/sakura/sakura.conf;
          ".config/Kvantum".source = ./configs/Kvantum; 
          ".config/qt5ct".source = ./configs/qt5ct;
          ".config/omf".source = config.lib.file.mkOutOfStoreSymlink ./configs/omf;
          ".config/fish".source = config.lib.file.mkOutOfStoreSymlink ./configs/fish;
          ".config/dconf".source = config.lib.file.mkOutOfStoreSymlink ./configs/dconf;
          ".config/Code".source = config.lib.file.mkOutOfStoreSymlink ./configs/Code;
          ".config/copyq".source = config.lib.file.mkOutOfStoreSymlink ./configs/copyq;
          ".config/Crow Translate".source = config.lib.file.mkOutOfStoreSymlink ./configs/CrowTranslate;

          ".themes/Seventeen-Light".source = ./themes/Seventeen-Light;
          ".icons".source = ./icons; 

          ".local/share/fonts".source = ./locals/fonts;
          ".local/share/fish".source = config.lib.file.mkOutOfStoreSymlink ./locals/fish;
          ".local/share/omf".source = config.lib.file.mkOutOfStoreSymlink ./locals/omf;
        };
      };
    };    
  };
  system.stateVersion = "22.11"; # Did you read the comment?

}
