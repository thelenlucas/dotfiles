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
  ];

  programs.git = {
    enable = true;
    userName = "Lucas Thelen";
    userEmail = "thelenlucas028@gmail.com";
  };

  programs.alacritty = { enable = true; };

  home.sessionVariables = { fish_greeting = "Good Morning."; };

  programs.fish = {
    enable = true;
    shellAliases = {
      g = "git";
      ls = "eza";
      "vim" = "nvim";
    };
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
