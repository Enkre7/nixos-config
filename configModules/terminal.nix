{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty
    fastfetch
    tree
    vim
    procps
    psmisc
    duf
    dust
    smartmontools
    file
    parted
  ];
  services.glances.enable = true;
}
