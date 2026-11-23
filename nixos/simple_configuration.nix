# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;

  # https://bugzilla.kernel.org/show_bug.cgi?id=110941
  # boot.kernelParams = [ "intel_pstate=no_hwp" ];
  
  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  
  boot.loader.grub.device = "/dev/nvme0n1p3";
     boot.initrd.luks.devices = [
  {
    name = "root";
    device = "/dev/nvme0n1p3";
    preLVM = true;
    allowDiscards = true;
  }
];

 environment.systemPackages = with pkgs; [
    htop wget vim
   ];
   
    # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
