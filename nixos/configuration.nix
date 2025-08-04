# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Extra modules
  boot.extraModulePackages = with config.boot.kernelPackages;
    [ rtl88xxau-aircrack ];

  nixpkgs.config.allowUnfree = true;

  # Allow flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.
  networking.networkmanager.wifi.powersave = false;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.steam.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    grim
    slurp
    gcc
    nil # Nix language server
    wl-clipboard
    bluetui
    cargo
    mako
    kdePackages.dolphin
    firefox
    udiskie
    neovim
    nixos-generators
    gnupg
    age
    fish
    cargo-generate
    git
    ansible
    plantuml
    kitty
    waybar
    direnv
    python311
    direnv
    font-awesome
    nixfmt-classic
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions;
        [
          rust-lang.rust-analyzer
          brettm12345.nixfmt-vscode
          github.vscode-github-actions
          jebbs.plantuml
          ms-vscode-remote.remote-ssh
          github.copilot
          github.copilot-chat
          vadimcn.vscode-lldb
          bbenoist.nix
          ms-python.python
          tamasfe.even-better-toml
          vscode-extensions.mkhl.direnv

        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "d2";
          publisher = "terrastruct";
          version = "0.8.8";
          sha256 = "sha256-nnljLG2VL7r8bu+xFOTBx5J2UBsdjOwtAzDDXKtK0os=";
        }];
    })
    wofi
  ];

  fonts.packages = with pkgs; [ fira nerd-fonts.fira-code font-awesome ];

  # Default editor
  environment.variables.EDITOR = "nvim";
  environment.variables.NIXOS_OZONE_WL = "1";

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;

  services.seatd.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
      addresses = true;
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };

  programs.fish.enable = true;

  programs.lazygit.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  users.users.lucas = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "docker" "dialout" "uaccess" "video" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGX9zNt4QTeDcfAPs8Hjfqmm1+dTeWZ6Wxx35RkVL0YL lucas@laptop"
    ];
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}

