{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bakerdn";
  home.homeDirectory = "/home/bakerdn";

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      bars = [{ command = "${config.programs.waybar.package}/bin/waybar"; }];
      output = {
        # Framework Laptop screen
        "Unknown 0x095F 0x00000000" = {
          mode = "2256x1504@60Hz";
          scale = "1.35";
        };
      };
    };
  };

  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    mako # notification daemon
    alacritty # terminal 
    wofi # launcher/menu program
    waybar # status bar
    # git tools
    git
    git-crypt
    gnupg
    pinentry_qt
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      background_opacity = 0.8;
      font.normal.family = "monospace";
      font.size = 11;
    };
  };

  programs.vim = {
    enable = true;
    settings = {
      background = "dark";
      expandtab = true;
      ignorecase = true;
      number = true;
      shiftwidth = 2;
      smartcase = true;
      tabstop = 2;
    };
    extraConfig = ''
      set autoindent
      set hlsearch
      set noincsearch
      set softtabstop=2
      set smarttab
      syntax on
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      lse = "ls -Fho";
      lsa = "lse -A";
    };
  };

  programs.git = {
    enable = true;
    userName = "Daniel Baker";
    userEmail = "daniel.baker@tweag.io";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
