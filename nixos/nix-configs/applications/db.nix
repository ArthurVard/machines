{ pkgs, ... }:

{

 # nixpkgs.overlays = [import ../../overlay/107-redis-tui.nix {}];
  environment.systemPackages = with pkgs; [

     # db servers
      postgresql
      redis
      mysql
      sqlite
      mongodb

     # db clients
      mycli
      pgcli
      #litecli
      pgcenter
      #redis-tui
      nodePackages.elasticdump
     ];
 }