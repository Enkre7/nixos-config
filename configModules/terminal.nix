{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty
    fastfetch
    tree
    vim
    procps
    psmisc
  ];
  services.glances.enable = true;
}
