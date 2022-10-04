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
  hardware.pulseaudio.enable = true;

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
      directories = [".emacs.d" ".gnupg"]; # mount these read-only?
    };
  };

  environment.variables = {EDITOR = "vim";};

  documentation.man.generateCaches = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    st
    dmenu
    firefox
    nsxiv
    mpv
    mupdf
    dig
    gnupg
    inputs.nixpkgs_head.legacyPackages.x86_64-linux.nyxt
    pinentry
    xclip
    tmux
    surf
    unzip
    yt-dlp
    rustc
    cargo
    rustfmt
    acpi
    libimobiledevice
    ifuse # uses libimobiledevice
    inputs.myConfig.packages.x86_64-linux.emacsConfig
    (import ./emacs.nix {inherit pkgs;})
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
    set -o vi
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "tty";
  };

  system.stateVersion = "22.05"; # Don't mess with this without reading the man page
}
