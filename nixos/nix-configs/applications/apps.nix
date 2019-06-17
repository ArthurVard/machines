{ pkgs, ... }:
{

    imports =
    [ # Include the results of the hardware scan.
      ./tmux.nix
      ./encryption.nix
    ];

  
  environment.systemPackages = with pkgs; [
    wget vimHugeX sudo coreutils
    manpages
    gitAndTools.gitFull
    git-crypt
    iptables nmap tcpdump
    zlib
    bc
    bash
    fuse3
    ntfs3g
    openvpn
    networkmanager-openvpn
    update-resolv-conf
    htop
    libreoffice
    gimp
    gwenview
    digikam5
    vlc 
    ark
    file 
    gnupg
    gzip
    unzip 
    cabal2nix
    peek 
    jq
    jid
    x11_ssh_askpass        
    htop

    # editors and IDE
    vim
    emacs
    vscode
    kate

    okteta # hex editor
    okular # pdf viewer
    
    # nix package for nix-shell etc
    binutils
    nix
    nix-prefetch-git
    nixops

    # OCaml
    ocaml
    ocamlPackages.utop
    ocamlPackages.camlp4
    opam


    # http clients
    http-prompt
    httplab
    curl
    wget
    httpie
    wuzz
    insomnia

    # X11 packages
    chromium
    firefoxWrapper
    trayer
    
    # proof assitance
    coq
    coqPackages.mathcomp

    # sync
    syncthing

    # Other applications
    dmenu
    xscreensaver
    xclip
    glxinfo
    tdesktop
    electrum
    steam
    rhythmbox
    pwgen
    
    
    # screenshot
    maim

    # misc
    haskellPackages.arbtt


    # text
     calibre
     djview
     djvulibre
     enca
     ghostscript
     pandoc

    # chat clients
    teamviewer
    w3m-full

  ];


}