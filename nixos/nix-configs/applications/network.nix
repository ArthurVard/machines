{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    networkmanager
    networkmanagerapplet
   ];

  # systemd.services.dhcpcd.serviceConfig.Type = lib.mkForce "simple";

#  networking.networkmanager = {
#    enable = true;
#   };
}