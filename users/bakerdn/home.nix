{
  config,
  pkgs,
  nur,
  nix-colors,
  ...
}: {
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

  imports = [
    ./bash.nix
    ./sway.nix
    ./kitty.nix
    ./waybar.nix
    nix-colors.homeManagerModule
  ];

  colorscheme = nix-colors.colorSchemes.nord;

  home.packages = with pkgs; [
    swaylock-effects
    swayidle
    wl-clipboard
    mako # notification daemon
    wofi # launcher/menu program
    # git tools
    git
    git-crypt
    gnupg
    pinentry_qt

    # graphical
    inkscape
    image-roll

    # download
    wget

    # console utilities
    bat
    ripgrep
    exa
    fd
    jq
    neofetch
  ];

  programs.firefox = import ./firefox {inherit pkgs;};

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

  programs.git = {
    enable = true;
    lfs.enable = true;
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
