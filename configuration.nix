# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Extra modules
  boot.extraModulePackages = with config.boot.kernelPackages;
    [ rtl88xxau-aircrack ];

  nixpkgs.config.allowUnfree = true;

  # Allow flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
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

  # Postgres
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "mydatabase" ];

    identMap = ''
      # ArbitraryMapName systemUser DBUser
         superuser_map      root      postgres
         superuser_map      postgres  postgres
         # Let other names login as themselves
         superuser_map      /^(.*)$   \1
    '';

    enableTCPIP = true;
    # port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      #...
      #type database DBuser origin-address auth-method
      local all       all     trust
      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
      CREATE DATABASE nixcloud;
      GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    '';
  };

  # System packages
  environment.systemPackages = with pkgs; [
    grim
    slurp
    wl-clipboard
    bluetui
    mako
    kdePackages.dolphin
    firefox
    inputs.helix.packages."${pkgs.system}".helix
    udiskie
    neovim
    nixos-generators
    fish
    cargo-generate
    git
    ansible
    plantuml
    kitty
    waybar
    zerotierone
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
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "probe-rs-debugger";
            publisher = "probe-rs";
            version = "0.21.2";
            sha256 = "0x82727qdrz2vf279n2vrzsi4bbyal8w3w8aqm0h9jmxd05y7f9x";
          }
          {
            name = "d2";
            publisher = "terrastruct";
            version = "0.8.8";
            sha256 = "12yj9ammrhrh0cnyr30x3d87d4n7q7j19cggdvyblbwmdln66ycy";
          }
        ];
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

  hardware.probe-rs.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  services.udev.extraRules = ''
    # Allied Vision Alvium 1800 U-501m – raw USB node
    SUBSYSTEM=="usb", ATTR{idVendor}=="1ab2", ATTR{idProduct}=="0001", MODE="0660", GROUP="video", SYMLINK+="alvium-%k"

    # If the camera registers as /dev/videoX instead, uncomment this:
    # SUBSYSTEM=="video4linux", ATTRS{idVendor}=="1ab2", ATTRS{idProduct}=="0001", MODE="0660", GROUP="video", SYMLINK+="alvium%n"

    # Radiacode

    SUBSYSTEM=="usb", \
      ATTR{idVendor}=="0483", \
      ATTR{idProduct}=="f123", \
      GROUP="dialout", \
      MODE="0660", \
      SYMLINK+="radia_code"
  '';

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

  programs.fish.enable = true;

  programs.lazygit.enable = true;

  # Zerotier network connection
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "8056c2e21cb25d85" ];
  };

  # Set your time zone.
  time.timeZone = "America/Denver";

  users.users.lucas = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "docker" "dialout" "uaccess" "video" ];
    shell = pkgs.fish;
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}

