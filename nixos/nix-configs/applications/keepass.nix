{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
   (self: super: {
    keepass-keepassrpc = super.keepass-keepassrpc.overrideAttrs (oldAttrs: {
        name = "keepassrpc-1.8.0";
        src = super.fetchurl {
          url    = "https://github.com/kee-org/keepassrpc/releases/download/v1.8.0/KeePassRPC.plgx";
          sha256 = "8d9d5e390fc4a3b8d6d8f24dd26a712dc032c4ff49708c8ec32c95a2e27594b5";
        };
    });
    keepass = super.keepass.override {
        plugins = [ self.keepass-keepassrpc pkgs.keepass-keeagent ];
    };
  })
];

  environment.systemPackages = with pkgs; [
    kpcli
    keepass
   ];
}