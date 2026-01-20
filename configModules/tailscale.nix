{ ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;     
    useRoutingFeatures = "both";
    extraUpFlags = ["--advertise-exit-node"];
  };  
    
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    checkReversePath = "loose";
  };
}
