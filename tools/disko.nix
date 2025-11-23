{
  device ? throw "Set this to your disk device, e.g. /dev/sda",
  swapSize ? "8G",
  ...
}: {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
                "umask=0022"
              ];
            };
          };
          swap = {
            size = swapSize;
            content = {
              type = "swap";
              randomEncryption = false;
              resumeDevice = true;
              priority = 100;
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "root_vg";
            };
          };
        };
      };
    };
    lvm_vg = {
      root_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = ["-f" "-L" "nixos"];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "x-initrd.mount"
                    "compress=zstd:1"
                    "noatime"
                    "space_cache=v2"
                    "discard=async"
                  ];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "x-initrd.mount"
                    "compress=zstd:3"
                    "noatime"
                    "space_cache=v2"
                    "discard=async"
                  ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "x-initrd.mount"
                    "compress=zstd:1"
                    "noatime"
                    "space_cache=v2"
                    "discard=async"
                  ];
                };
                "/log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                    "space_cache=v2"
                    "discard=async"
                  ];
                };
                "/snapshots" = {
                  mountpoint = "/snapshots";
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                    "space_cache=v2"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
