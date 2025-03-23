{ pkgs, ... }: 

{  
  # Keyrings
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  programs.seahorse.enable = true; # Keyring manager
  security.polkit.enable = true;

  security.pam = {
    services = {
      sudo.sshAgentAuth = true;
    };
    sshAgentAuth.enable = true;
  };
  security.sudo.execWheelOnly = true;

  services.fail2ban = {
    enable = true;
    # Protect from SSH brute force
    jails.ssh-iptables = ''
      enabled = true
      filter = sshd
      maxretry = 5
      bantime = 2h
    '';
  };

  security.auditd.enable = true;

  # Harden kernel
  boot.kernel.sysctl = {
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
    "kernel.yama.ptrace_scope" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.kexec_load_disabled" = 1;
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;
  };

  environment.systemPackages = with pkgs; [
    libsecret # Polkit  
    lxqt.lxqt-policykit # Polkit
    pinentry
  ];
}
