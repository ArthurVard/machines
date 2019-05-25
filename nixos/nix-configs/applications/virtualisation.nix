{ pkgs, ... }:
{

virtualisation = {
    libvirtd.enable = true;	
    virtualbox = {
      host = {
        enable              = true;
        enableHardening     = false;
        enableExtensionPack = true;
        headless            = false;
      };
    };

    docker = {
      enable           = true;
      enableOnBoot     = true;
      autoPrune.enable = true;
      liveRestore      = false;
      # storageDriver = "overlay2";

    };
  };

 environment.systemPackages = with pkgs; [
        ctop
        dive
        docker-machine
        docker_compose
        libcgroup
        skopeo

	# virtualization
	vagrant
    ];

}