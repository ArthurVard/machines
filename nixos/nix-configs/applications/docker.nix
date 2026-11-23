{ pkgs, ... }:

{
  virtualisation.docker = {
      enable           = true;
     # enableOnBoot     = true;
      autoPrune.enable = true;
      liveRestore      = false;
      # storageDriver = "overlay2";

    };


  environment.systemPackages = with pkgs; [
      docker-machine
      docker_compose
      skopeo
      ];
 }