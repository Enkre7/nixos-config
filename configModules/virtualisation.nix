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
}
