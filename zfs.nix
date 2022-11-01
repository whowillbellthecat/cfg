{
  config,
  pkgs,
  ...
}: {
  boot.supportedFilesystems = ["zfs"];
  networking.hostId = "17bc337b";
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.generationsDir.copyKernels = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;

## This code is from https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS/3-system-configuration.html
## However, it has issues. Notably, it adds a new set of mounts every run until a limit is hit and errors occur
## FIXME: investigate the intentions behind this and/or rewrite it to fix these errors.
  boot.loader.grub.extraPrepareConfig = ''
    mkdir -p /boot/efis
    for i in /boot/efis/*; do mount "$i" ; done

    mkdir -p /boot/efi
    mount /boot/efi
  '';
  boot.loader.grub.extraInstallCommands = ''
    ESP_MIRROR=$(mktemp -d)
    cp -r /boot/efi/EFI "$ESP_MIRROR"
    for i in /boot/efis/*; do cp -r "$ESP_MIRROR"/EFI "$i" ; done
    rm -rf "$ESP_MIRROR"
  '';
  boot.loader.grub.devices = [
    "/dev/disk/by-id/nvme-SAMSUNG_MZVLB256HBHQ-000L7_S4ELNF3N570089"
  ];
}
