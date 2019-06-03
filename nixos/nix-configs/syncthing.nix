{ config, pkgs, ... } :
{

   services.syncthing = {
	 enable = true;
	 all_proxy = null;
	 dataDir = "/home/arthur";
	 user = "arthur";
	 openDefaultPorts = true;
     };

 }