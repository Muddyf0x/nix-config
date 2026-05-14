{ pkgs, ... }: {

  # On every boot, delete the ephemeral /root subvolume and replace it with a
  # fresh snapshot of /root-blank. Runs in initrd after LUKS is unlocked but
  # before the root filesystem is mounted by the rest of the system.
  boot.initrd.systemd.services.rollback = {
    description = "Rollback btrfs root subvolume to blank snapshot";
    wantedBy = [ "initrd.target" ];
    after = [ "dev-mapper-cryptroot.device" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "rollback" ''
        mkdir -p /mnt
        mount -t btrfs -o subvol=/ /dev/mapper/cryptroot /mnt
        btrfs subvolume delete /mnt/root
        btrfs subvolume snapshot /mnt/root-blank /mnt/root
        umount /mnt
      '';
    };
  };

  # btrfs-progs must be in the initrd for the rollback script above.
  boot.initrd.systemd.storePaths = [ pkgs.btrfs-progs ];

  # Bind-mount persistent paths from /persist into the ephemeral root.
  # /var/lib, /var/log, and /home are on their own btrfs subvolumes and are
  # already persistent — only /etc paths that must survive reboots go here.
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [ "/etc/ssh" ];
    files = [ "/etc/machine-id" ];
  };
}
