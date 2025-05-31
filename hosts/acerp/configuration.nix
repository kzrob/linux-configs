{ config, pkgs, inputs, system, ... }:

{
  # PACKAGES AND VARIABLES
  users.users.kzrob = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "input" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    # Hyprland
    hyprland #compositor
    hyprpaper #wallpaper
    hyprshot #screenshot
    waybar #taskbar
    dunst #notifications
    rofi-wayland #start menu
    networkmanagerapplet

    # Editor/IDE
    vim
    neovim
    kdePackages.kate
    vscode-fhs
    arduino-ide

    # Z-shell
    zsh
    oh-my-zsh

    # CLI Utilities
    wget
    curl
    git
    btop
    fastfetch
    wl-gammactl

    # Office
    inputs.zen-browser.packages.x86_64-linux.twilight
    libreoffice
    gimp
    blender

    # Compatibility
    wineWowPackages.stable
    bottles

    # Media
    mpv
    obs-studio

    # Learning
    anki
  ];

  environment.variables = {
    XDG_CONFIG_HOME = "~/nixos/dots";
    HYPRLAND_CONFIG_PATH = "~/nixos/dots/hypr";

    HYPRSHOT_DIR = "~/Pictures/screenshots";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    noto-fonts-cjk-sans
  ];

  # PROGRAM CONFIGS
  programs.hyprland.enable = true;
  programs.firefox.enable = true;
  programs.steam.enable = true;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "bureau";
    };
  };

  programs.git.config = {
    enable = true;
    userName = "kzrob";
    userEmail = "davidyo571@gmail.com";
  };
/*
  inputs.zen-browser.packages."${system}".twilight.override = {
    enable = true;
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
    };
  };
*/

  # SYSTEM
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
  };

  boot = {
    tmp.cleanOnBoot = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
  }];

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 443 80 22 ];
      allowedUDPPorts = [ 53 22 ];
    };
  };

  # Localization
  time.timeZone = "America/New_York";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "zh_CN.UTF-8/UTF-8" ];
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chinese-addons
        fcitx5-nord
      ];
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Useful services
  hardware.bluetooth.enable = true;
  services.flatpak.enable = true;
  services.libinput.enable = true; # touchpad support
  services.printing.enable = true;

  # Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Wayland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  # Hyprland
  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
  };

  # read ($man configuration.nix) or https://nixos.org/nixos/options.html
  system.stateVersion = "24.11";
}
