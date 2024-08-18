{ ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;     
    useRoutingFeatures = "both";
    extraUpFlags = ["--advertise-exit-node"]; # use as exit node
  };  
    
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    # required to connect to Tailscale exit nodes
    checkReversePath = "loose";
  };
}
