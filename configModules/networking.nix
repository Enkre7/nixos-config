{ config, lib, pkgs, ... }:

{
  networking = {
    hostName = config.hostname;
    useDHCP = lib.mkDefault true;
    wireless.enable = lib.mkForce false;

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.backend = "iwd";
    };

    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          EnableNetworkConfiguration = false;
          AddressRandomization = "network";
          ControlPortOverNL80211 = false;
        };
      };
    };
  };
  
  services.resolved.enable = true;

  # Network discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  #Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings.General = {
    Experimental = true;
    FastConnectable = true;
    JustWorksRepairing = "always";
  };
  services.blueman.enable = true;

  # Firewall
  networking.firewall = rec {
    enable = true;
    allowedTCPPorts = [
      27036 # Steam
      27037 # Steam
    ];
    allowedUDPPorts = [
      27031 # Steam
      27036 # Steam
      41641 # Tailscale
      5353 # mDNS/Avahi
      1 # Bluetooth discovery
    ];
    allowedTCPPortRanges = [
      { from = 27015; to = 27030; } # Steam remote play
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;

    trustedInterfaces = [ "tailscale0" "lo" "docker0" ];
    allowPing = true;
    checkReversePath = "loose"; # for VPN
    extraCommands = ''
      iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    '';
  };

  # SSH
  services.gnome.gcr-ssh-agent.enable = false;
  programs.ssh.startAgent = false;
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = false;
      AllowUsers = [ config.user ];
      AllowGroups = [ "wheel" config.user];
    };
    extraConfig = ''
      LoginGraceTime 30
      MaxAuthTries 4
      ClientAliveInterval 300
      ClientAliveCountMax 2
    '';
  };

  # Usefull packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    iperf
    nmap
    netcat
    networkmanagerapplet
    lsof
    iw
    wavemon
    dnsutils
  ];
}
