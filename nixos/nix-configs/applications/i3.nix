{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
     dmenu     # for app launcher
     feh       # for background image
     i3
     i3lock    # screen lock
     i3status  # sys info
     scrot     # for screenshot

   ];
}