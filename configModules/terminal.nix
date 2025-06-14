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
  ];
  services.glances.enable = true;
}
