{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "rpool/nixos/root";
      fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];
    };

  fileSystems."/data" =
    { device = "rpool/nixos/home";
      fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];
      neededForBoot = true; # impermanence.nix requires this
    };

   fileSystems."/home/satori" =
   {
    device = "none";
    fsType = "tmpfs";
    options = [ "size=2G" ];
  };

  fileSystems."/var/lib" =
    { device = "rpool/nixos/var/lib";
      fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];
    };

  fileSystems."/var/log" =
    { device = "rpool/nixos/var/log";
      fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];
    };

  fileSystems."/boot" =
    { device = "bpool/nixos/root";
      fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];
    };

  fileSystems."/boot/efis/nvme-SAMSUNG_MZVLB256HBHQ-000L7_S4ELNF3N570089-part1" =
    { device = "/dev/disk/by-uuid/F88A-FE60";
      fsType = "vfat";
    };

  fileSystems."/boot/efi" =
    { device = "/boot/efis/nvme-SAMSUNG_MZVLB256HBHQ-000L7_S4ELNF3N570089-part1";
      fsType = "none";
      options = [ "bind" ];
    };

  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
