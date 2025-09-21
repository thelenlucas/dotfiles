# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    udiskie
    neovim
    iosevka # Font
    nixos-generators
    gnupg
    age
    fish
    cargo-generate
    git
    ansible
    direnv
    python311
    font-awesome
    nixfmt-classic
  ];

  fonts.packages = with pkgs; [ fira nerd-fonts.fira-code font-awesome ];

  # Default editor
  environment.variables.EDITOR = "nvim";

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
    extraGroups = [ "wheel" "networkmanager" "dialout" "uaccess" "video" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGX9zNt4QTeDcfAPs8Hjfqmm1+dTeWZ6Wxx35RkVL0YL lucas@laptop"
    ];
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}

