{ config, lib, pkgs, inputs, ... }: {
  # Get ozone apps to work in wayland
  environment.variables.NIXOS_OZONE_WL = "1";
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.systemPackages = with pkgs; [
    kitty
    waybar
    kdePackages.dolphin
    firefox
    wofi
  ];
}
