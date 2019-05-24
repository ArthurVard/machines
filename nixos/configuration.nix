# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nix-configs/users.nix
      ./nix-configs/xserver.nix
      ./nix-configs/fonts.nix
      ./nix-configs/private-ssh-pipe.nix
      ./nix-configs/applications
      # ./nix-configs/syncthing.nix

    ];


   services.private-ssh-pipe.enable = true;
   services.private-ssh-pipe.user = "arthur";
   

   services.syncthing = {
	 enable = true;
	 all_proxy = null;
	 dataDir = "/home/arthur";
	 user = "arthur";
	 openDefaultPorts = true;
     };


   nixpkgs.config = {
    allowUnfree = true;
    #packageOverrides = pkgs: {
     # unstable = import unstableTarball {
      #  config = config.nixpkgs.config;
     # };
   # };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

   boot.initrd.luks.devices = [
  {
    name = "root";
    device = "/dev/sda3";
    preLVM = true;
  }
];

boot.kernelPackages = pkgs.linuxPackages_latest;

boot.loader.grub.device = "/dev/sda";
fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
   
    
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Yerevan";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
   kate  htop wget vim emacs chromium mc 
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  services.upower.enable = true;     

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
   



  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  security.sudo.enable = true;


  # Set up nix caches - https://github.com/obsidiansystems/obelisk
  nix.binaryCaches = [ "https://cache.nixos.org" "https://nixcache.reflex-frp.org" "https://hydra.iohk.io"];
  nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];


#  nix.binaryCaches = [ "https://cache.nixos.org" "https://nixcache.reflex-frp.org" "ssh://nix-ssh@cache.hxr.team"  "https://hydra.iohk.io"];
#  nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" "cache.hxr.team-1:hMN5cbH9fBQ/GhiZ4KlT2zXB18+/5AeMae1frHrDtrg=" "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];

  nix.distributedBuilds = true; # workaround for https://github.com/NixOS/nixpkgs/issues/46038
  nix.trustedUsers = [ "root" "arthur" ];
  nix.requireSignedBinaryCaches = true;
  nix.useSandbox = "relaxed";

  networking.firewall.allowedTCPPorts = [ 22 6881 ];
  networking.firewall.allowedUDPPorts = [ 8881 ];

  # Enable sound.
  sound.enable = true;

  # hardwre
  hardware = {
    cpu.intel.updateMicrocode = true;
    cpu.amd.updateMicrocode = false;
    enableAllFirmware = true;

    bluetooth.enable = true;

    pulseaudio = {
     	enable = true;	
	# For Seam	
	support32Bit = true;
	# For bt headphones
	package = pkgs.pulseaudioFull;
    };

    opengl = {
       enable = true;
       driSupport = true;
       # For Steam
       driSupport32Bit = true;
    };
 };
    

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}

