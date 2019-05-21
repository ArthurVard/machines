{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    
    displayManager.lightdm = {
      enable = true;
    };

   desktopManager = {
                plasma5 = {
			enable = true;
			enableQt4Support = false;
			};
   		xterm.enable = false;
                gnome3.enable = false;
		
                default = "none";
            };    

    windowManager = {
        default = "none";

        i3 = {
      	   enable = true;
      	   package = pkgs.i3-gaps;
    	   };

        xmonad = {
            enable = true;
            enableContribAndExtras = true;
            extraPackages = p: [ p.dbus p.monad-logger p.lens p.split ];
        };
    };
#    environment.systemPackages = with pkgs; [
 #       haskellPackages.xmobar
 #   ];

    
    # Enable touchpad support for many laptops.
    synaptics.enable = true;

    # Russian layout
    xkbModel = "microsoft";
    layout = "us,ru,am";
    xkbVariant = ",,";
    #xkbOptions = "grp:alt_shift_toggle";

  };

}