{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
     xterm
#     mate
     rxvt_unicode
 #    st
  ];
}