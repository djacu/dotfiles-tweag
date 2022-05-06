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
      terminal = "${pkgs.kitty}/bin/kitty";
      bars = [{ command = "${config.programs.waybar.package}/bin/waybar"; }];
      output = {
        # Framework Laptop screen
#        "Unknown 0x095F 0x00000000" = {
#          mode = "2256x1504@60Hz";
#          scale = "1.35";
#        };
      };
    };
  };

  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    mako # notification daemon
    wofi # launcher/menu program
    # git tools
    git
    git-crypt
    gnupg
    pinentry_qt
  ];

  programs.kitty = {
    enable = true;
    settings.open_url_with = "firefox";
    settings.copy_on_select = "clipboard";
    settings.tab_bar_edge = "top";
    settings.enable_audio_bell = "no";
    #settings.font_family = "Fire Code Light";
    #settings.italic_font = "Fire Code Light";
    #settings.bold_font = "Fire Code Light";
    #settings.bold_italic_font = "Fire Code Light";
    #settings.font_size = 11.0;

    font.name = "Fire Code Light";
    font.size = 11;

    # TODO:
    #theme
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
  # home.stateVersion = "21.11";
}
