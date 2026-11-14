{ config, lib, ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;     
    useRoutingFeatures = "both";
    extraSetFlags = [ "--operator=${config.user}" ] ++ lib.optional (!config.isLaptop) "--advertise-exit-node";
  };  
    
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    checkReversePath = "loose";
  };
}
