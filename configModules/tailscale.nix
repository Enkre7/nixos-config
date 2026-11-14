{ config, ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;     
    useRoutingFeatures = "both";
    extraSetFlags = [ "--advertise-exit-node" "--operator=${config.user}" ];
  };  
    
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    checkReversePath = "loose";
  };
}
