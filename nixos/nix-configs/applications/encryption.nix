{ pkgs, ... }:

{

    imports =
    [
	./keepass.nix
    ];
  environment.systemPackages = with pkgs; [
    gnupg
    pass

   ];
}