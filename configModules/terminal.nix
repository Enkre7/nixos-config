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
  ];
  services.glances.enable = true;
}
