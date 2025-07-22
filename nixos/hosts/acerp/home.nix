{ config, pkgs, inputs, ... }:

let
  prism = {
    url = "https://github.com/Diegiwg/PrismLauncher-Cracked/releases/tag/9.4/PrismLauncher-Linux-Qt5-Portable-9.4.tar.gz";
    sha256 = "";
  };
in
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  home.username = "kzrob";
  home.homeDirectory = "/home/kzrob";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    # HYPRLAND
    hyprland #compositor
    hyprpaper #wallpaper
    hyprshot #screenshot
    waybar #taskbar
    dunst #notifications
    rofi-wayland #start menu

    # HYPRLAND UTILS
    networkmanagerapplet

    # Office and graphics
    libreoffice
    gimp
    blender

    # Compatibility
    wineWowPackages.stable
    bottles

    # zsh
    zsh
    oh-my-zsh

    # Development tools
    vscode-fhs
    arduino-ide

    # Learning
    anki

    # Media
    mpv
    obs-studio

    # Gaming
    #TODO: import (fetchTarball prism)
  ];

  # TODO: I think this is where we do dotfile configs through nix 
  programs.zsh.enable = true;
  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "bureau";
  };

  programs.git = {
    enable = true;
    userName = "kzrob";
    userEmail = "davidyo571@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.zen-browser = {
    enable = true;
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
    };
  };

  home.file = {
    ".config/hypr/hyprland.conf".source = ./../../dots/hypr/hyprland.conf;
    ".config/hypr/hyprpaper.conf".source = ./../../dots/hypr/hyprpaper.conf;
    
    ".config/waybar/config.jsonc".source = ./../../dots/waybar/config.jsonc;
    ".config/waybar/style.css".source = ./../../dots/waybar/style.css;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kzrob/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    HYPRSHOT_DIR = "~/Pictures/screenshots";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
