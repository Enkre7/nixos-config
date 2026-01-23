{ config, pkgs, ...}:
{
  # System Management Tool
  programs.dconf.enable = true;
  # Libvirtd
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
  users.extraGroups.libvirtd.members = [ config.user ];
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-spice
    virtio-win
    virtiofsd
  ];
  # VirtIO-FS service for Downloads sharing
  systemd.services.virtiofsd-downloads = {
    description = "VirtIO-FS daemon for Downloads folder";
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.virtiofsd}/bin/virtiofsd --socket-path=/var/lib/libvirt/virtiofsd-downloads.sock --shared-dir=/home/enkre/Downloads --cache=auto";
      Restart = "always";
      User = "root";
    };
  };

  # Samba for Windows VMs
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "NixOS Samba Server";
        "netbios name" = "promethium";
        "security" = "user";
      };
      downloads = {
        path = "/home/enkre/Downloads";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "enkre";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  # Firewall for libvirt network
  networking.firewall.interfaces."virbr0" = {
    allowedTCPPorts = [ 139 445 ];
    allowedUDPPorts = [ 137 138 ];
  };
}
