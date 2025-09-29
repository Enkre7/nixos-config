{ config, lib, pkgs, ... }:

{
  networking = {
    hostName = config.hostname;
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    useDHCP = lib.mkDefault true;
  };

  # Network discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  #Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Firewall
  networking.firewall = rec {
    enable = true;
    allowedTCPPorts = [
      22 # SSH
      27036 # Steam
      27037 # Steam
      53 # DNS
      4447 # Mullvad VPN
      631 # CUPS
    ];
    allowedUDPPorts = [
      27031 # Steam
      27036 # Steam
      1194 # Mullvad VPN
      1195 # Mullvad VPN
      1196 # Mullvad VPN
      1197 # Mullvad VPN
      51820 # Mullvad VPN
      41641 # Tailscale
      5353 # mDNS/Avahi
      631 # CUPS
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
  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
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
  ];
}
