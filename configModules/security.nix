{ pkgs, ... }: 

{
  # PAM
  services.gnome.gnome-keyring.enable = true;
  security.pam = {
    services = {
      sudo.sshAgentAuth = true;
      greetd.enableGnomeKeyring = true; 
      login.enableGnomeKeyring = true; 
    };
    sshAgentAuth.enable = true;
  };
  security.sudo.execWheelOnly = true;
  programs.ssh.extraConfig = ''
    AddKeysToAgent yes
  '';
  
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
  
  
  # Fail2ban
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
  
  
  # Polkit
  security.polkit.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (
            subject.isInGroup("users")
                && (
                    action.id == "org.freedesktop.login1.reboot" ||
                    action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                    action.id == "org.freedesktop.login1.power-off" ||
                    action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                )
            )
        {
            return polkit.Result.YES;
        }
    })
  '';

  environment.systemPackages = with pkgs; [
    libsecret
  ];
}
