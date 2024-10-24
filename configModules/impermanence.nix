{ lib, ... }:

{
  # Clean boot script
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  # Allow impermanence to home-manager directories
  programs.fuse.userAllowOther = true;

  # Persistance on dirs & files
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      { directory = "/nixos"; user = "root"; group = "root"; mode = "0755"; }
      { directory = "/var/lib/nixos"; user = "root"; group = "root"; mode = "0755"; }
      { directory = "/var/log"; user = "root"; group = "root"; mode = "0755"; }
      { directory = "/var/lib/systemd"; user = "root"; group = "root"; mode = "0755"; }
      { directory = "/var/tmp"; user = "root"; group = "root"; mode = "1777"; }
      { directory = "/var/spool"; user = "root"; group = "root"; mode = "0777"; }
      { directory = "/tmp"; user = "root"; group = "root"; mode = "1777"; }      
      
      # Mullvad
      { directory = "/etc/mullvad-vpn"; user = "root"; group = "root"; mode = "0700"; }
      { directory = "/var/cache/mullvad-vpn"; user = "root"; group = "root"; mode = "0755"; }

      # libvirt / Quemu
      { directory = "/var/lib/libvirt"; user = "root"; group = "root"; mode = "0755"; }
      { directory = "/var/lib/swtpm-localca"; user = "root"; group = "root"; mode = "0750"; }
      
      # DHCP
      { directory = "/var/db/dhcpcd"; user = "root"; group = "root"; mode = "0755"; }
      
      # Printing
      { directory = "/var/lib/cups"; user = "root"; group = "root"; mode = "0755"; }

      # Sudo
      { directory = "/var/db/sudo/lectured"; user = "root"; group = "root"; mode = "0700"; }
    ];
    files = [
      "/etc/machine-id"
      "/etc/adjtime"
      #{ file = "/etc/machine-id"; parentDirectory = { mode = "u=r,g=r,o=r"; }; }
      #{ file = "/etc/adjtime"; parentDirectory = { mode = "u=rw,g=r,o=r"; }; }
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
  };
}
