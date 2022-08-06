{
  config,
  pkgs,
  ...
}: {
  boot.supportedFilesystems = ["zfs"];
  networking.hostId = "145e54cd";
  boot.zfs.devNodes = "/dev/disk/by-id";
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_17;
  swapDevices = [
    {
      device = "/dev/disk/by-id/nvme-SKHynix_HFS512GDE9X081N_CD13N445112003740-part4";
      randomEncryption.enable = true;
    }
  ];
  systemd.services.zfs-mount.enable = false;
  environment.etc."machine-id".source = "/state/etc/machine-id";
  environment.etc."zfs/zpool.cache".source = "/state/etc/zfs/zpool.cache";
  boot.loader.efi.efiSysMountPoint = "/boot/efis/nvme-SKHynix_HFS512GDE9X081N_CD13N445112003740-part1";
  boot.loader.efi.canTouchEfiVariables = false;
  # if UEFI firmware can detect entries
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.loader = {
    generationsDir.copyKernels = true;
    # for problematic UEFI firmware
    grub.efiInstallAsRemovable = true;
    grub.enable = true;
    grub.version = 2;
    grub.copyKernels = true;
    grub.efiSupport = true;
    grub.zfsSupport = true;
    # for systemd-autofs
    grub.extraPrepareConfig = ''
      mkdir -p /boot/efis
      for i in /boot/efis/*; do mount $i ; done
    '';
    grub.extraInstallCommands = ''
      export ESP_MIRROR=$(mktemp -d -p /tmp)
      cp -r /boot/efis/nvme-SKHynix_HFS512GDE9X081N_CD13N445112003740-part1/EFI $ESP_MIRROR
      for i in /boot/efis/*; do
        cp -r $ESP_MIRROR/EFI $i
      done
      rm -rf $ESP_MIRROR
    '';
    grub.devices = [
      "/dev/disk/by-id/nvme-SKHynix_HFS512GDE9X081N_CD13N445112003740"
    ];
  };
  boot.loader.grub.gfxmodeEfi = "1024x768";
  users.users.root.initialHashedPassword = "$6$vFZp8B.7712ON11$SvdClJ0jw1SqxHaMQ4boeYH1Jrd4hQWAHu1PHSebPS4.M8A.unwUUrpRAtyPt6nTucQdgybLNlUXNjNzthDzj1";
}
