{ pkgs, ... }:
{
 fonts = {
    fontconfig = {
     
      enable = true;
     
      defaultFonts = {
        monospace = [ "Roboto Mono 13" ];
        sansSerif = [ "Roboto 13" ];
        serif = [ "Roboto Slab 13" ];
      };
    };
 
    enableDefaultFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fonts = with pkgs; [
      anonymousPro
      emacs-all-the-icons-fonts
      inconsolata
      terminus_font
      opensans-ttf
      roboto
      roboto-mono
      roboto-slab
      powerline-fonts
      noto-fonts
      noto-fonts-emoji
      #fira-code-symbols
      hasklig
      #keystroke
    ];


};

}
