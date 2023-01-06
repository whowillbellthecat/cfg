{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./zfs.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "sotto-voce";
  networking.wireless.enable = true;
  networking.nameservers = ["1.1.1.1"];

  time.timeZone = "America/Chicago";
  virtualisation.docker.rootless.enable = true;
  systemd.services."user@".serviceConfig = {Delegate = "yes";};

  # Select internationalisation properties.
  #i18n.defaultLocale = "en_US.UTF-8";
  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "dvorak";
  #  useXkbConfig = true; # use xkbOptions in tty.
  #};

  services.xserver.enable = true;
  services.xserver.layout = "dvorak";
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.xkbOptions = "caps:escape";
  services.xserver.libinput.enable = true; # touchpad support

  services.usbmuxd.enable = true;

  sound.enable = true;

  users.mutableUsers = false;
  users.users.satori = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio"];
    home = "/home/satori";
    passwordFile = "/data/satori.passwd";
  };
  users.users.root = {
    passwordFile = "/data/root.passwd";
  };

  environment.persistence."/data" = {
    users.satori = {
      directories = [".emacs.d" ".gnupg" ".task" ".timewarrior"]; # mount some of these read-only?
    };
  };

  environment.variables = {
    EDITOR = "vim";
  };

  documentation.man.generateCaches = true;

  environment.systemPackages = with pkgs; [
    rlwrap
    gh
    taskwarrior
    timewarrior
    anki
    tetex # required by anki to support [latex] in cards
    # linuxKernel.packages.linux_5_19.perf
    (vim_configurable.customize {
      name = "vim";
      vimrcConfig.customRC = ''
        autocmd FileType v :packadd Coqtail
        syntax enable
      '';
      vimrcConfig.packages.pkg = with pkgs.vimPlugins; {
        opt = [Coqtail];
      };
    })
    wget
    st
    dmenu
    firefox
    nsxiv
    mpv
    mupdf
    dig
    gnupg
    inputs.nixpkgs_head.legacyPackages.x86_64-linux.sqlite
    pinentry
    xclip
    tmux
    surf
    unzip
    yt-dlp
    rustc
    rust-analyzer
    qemu
    coq
    cargo
    acpi
    libimobiledevice
    ifuse # uses libimobiledevice
  ];
  programs.git.enable = true;
  programs.git.config = {
    user = {
      email = "everythingisbotnet@protonmail.com";
      name = "Christopher Arnold";
    };
  };

  # is there a better way to set this (e.g., via readline)
  programs.bash.interactiveShellInit = ''
    export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
    set -o vi
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "tty";
  };

  system.stateVersion = "22.05"; # Don't mess with this without reading the man page
}
