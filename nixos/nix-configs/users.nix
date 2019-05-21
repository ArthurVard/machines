{ pkgs, ... }:

{
 users.extraUsers.arthur = {
   name = "arthur";
   group = "users";
   extraGroups = ["wheel" "disk" "audio" "video" "vboxusers" "docker" "networkmanager" "systemd-journal" ];
   description = "Arthur Vardanyan";
   createHome = true;
   uid = 1000;
   home = "/home/arthur";
   isSystemUser = false;
   useDefaultShell = true;
  
 };

  security.sudo = {
    enable = true;
    extraConfig = ''
    arthur ALL = (root) NOPASSWD: /run/current-system/sw/bin/nixos-rebuild switch
    '';
  };

}