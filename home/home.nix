{ configs, pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch

    # Utils
    nnn
    ripgrep
    eza
    fzf
    tree
    git
    meld
    gource # Git visualizer
    jujutsu # Git replacement
    lazyjj
    markdownlint-cli2
    unzip
    nemo-with-extensions

    # I like
    d2
    calibre

    # nvim
    vimPlugins.nvim-lspconfig

    # Haskell
    ghc
    haskell-language-server

    # x-top
    btop
    iotop
    iftop

    # System utils
    pciutils
    usbutils

    # My stuff
    obsidian
    discord

    # Geforce now :(
    chromium
  ];

  programs.git = {
    enable = true;
    userName = "Lucas Thelen";
    userEmail = "thelenlucas028@gmail.com";
  };

  programs.alacritty = {
    enable = true;
    theme = "base16_default_dark";
  };
  services.udiskie = {
    enable = true;
    settings = {
      # workaround for
      # https://github.com/nix-community/home-manager/issues/632
      program_options = {
        # replace with your favorite file manager
        file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
      };
    };
  };
  fonts.fontconfig.enable = true;

  home.sessionVariables = { fish_greeting = "Good Morning."; };

  programs.fish = {
    enable = true;
    shellAliases = {
      g = "git";
      ls = "eza";
      "vim" = "nvim";
    };
  };

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
