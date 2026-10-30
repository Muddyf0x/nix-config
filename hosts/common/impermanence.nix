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
    serviceConfig.Type = "oneshot";
    # Use `script`, not `ExecStart = pkgs.writeShellScript ...`: NixOS copies a
    # `script` into the initrd automatically, a bare ExecStart path it does not,
    # and the service then fails with "Unable to locate executable".
    # The script runs with `set -e`, so if any step fails, root is left alone.
    script = ''
      mkdir -p /mnt
      mount -t btrfs -o subvol=/ /dev/mapper/cryptroot /mnt
      # Without the blank snapshot we could delete root but not recreate it.
      if [ ! -d /mnt/root-blank ]; then
        echo "no /root-blank snapshot, leaving root alone"
        umount /mnt
        exit 1
      fi
      # --recursive: systemd creates /tmp, /var/tmp and /srv as subvolumes
      # inside root, and a plain delete refuses a subvolume that has others in it.
      btrfs subvolume delete --recursive /mnt/root
      btrfs subvolume snapshot /mnt/root-blank /mnt/root
      umount /mnt
    '';
  };

  # btrfs-progs must be in the initrd for the rollback script above.
  boot.initrd.systemd.storePaths = [ pkgs.btrfs-progs ];

  # Bind-mount persistent paths from /persist into the ephemeral root.
  # /var/lib, /var/log, and /home are on their own btrfs subvolumes and are
  # already persistent — only /etc paths that must survive reboots go here.
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/ssh"
      # Saved Wi-Fi networks and VPN profiles
      "/etc/NetworkManager/system-connections"
    ];
    files = [ "/etc/machine-id" ];
  };
}
