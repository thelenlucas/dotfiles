{ config, lib, pkgs, inputs, ... }: {
  networking.firewall.allowedTCPPorts = [
    6443 # k3s API server
  ];
  services.k3s.enable = true;
  services.k3s.role = "server";
}
