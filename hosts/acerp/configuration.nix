{ config, pkgs, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
  };

  boot = {
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
  }];

  users.users.kzrob = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "input" ];
  };

  networking = {
    networkmanager.enable = true;
    wireless.enable = true;  # enables wpa_supplicant
    wireless.iwd.enable = true;
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

  # Wayland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    gtkUsePortal = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    noto-fonts-cjk-sans
  ];

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
    media-session.enable = true;
  };

  # Hyprland
  programs.hyprland.enable = true;

  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Install programs.
  programs.firefox.enable = true;
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    btop
    fastfetch
    wl-gammactl
  ];

  # read ($man configuration.nix) or https://nixos.org/nixos/options.html
  system.stateVersion = "24.11";
}
