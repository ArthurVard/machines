
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # screencasts
    vokoscreen
    obs-studio
    keymon

    ffmpeg
   ];
}
 