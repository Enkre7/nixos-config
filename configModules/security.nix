{ pkgs, ... }: 

{  
  # Keyrings
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  programs.seahorse.enable = true; # Keyring manager

  security.polkit.enable = true;


  services.fail2ban = {
    enable = true;
    # Protect from SSH brute force
    jails.ssh-iptables = ''
      enabled = true
      filter = sshd
      maxretry = 5
      bantime = 1h
    '';
  };

  security = {
    pam.sshAgentAuth.enable = true;
    sudo.execWheelOnly = true;
  };  
  # Harden kernel
  boot.kernel.sysctl = {
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
    "kernel.yama.ptrace_scope" = 1;
  };

  environment.systemPackages = with pkgs; [
    libsecret # Polkit  
    lxqt.lxqt-policykit # Polkit 
    vulnix       #scan command: vulnix --system
    chkrootkit   #scan command: sudo chkrootkit
    lynis
  ];
}
