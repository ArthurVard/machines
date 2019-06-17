{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ansible
    ansible-lint
    terraform
    drone
    drone-cli
  ];
}