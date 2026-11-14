{ ... }:

{
  services.mullvad-vpn = {
    enable = true;
    gui.enable = false;
  };
  services.resolved.enable = true;
}
