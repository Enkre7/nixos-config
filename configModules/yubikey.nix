{ config, pkgs, lib, ...}:

{
  services.pcscd.enable = true;  
  services.yubikey-agent.enable = false;
  programs.yubikey-touch-detector.enable = true;
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  services.udev.packages = with pkgs; [ 
    yubikey-personalization 
    libu2f-host 
    gnupg 
  ];

  environment.systemPackages = with pkgs; [
    gnupg
    pinentry-curses
    pinentry-qt
    paperkey  # For GPG keys backup
    
    yubico-piv-tool
    yubikey-personalization
    yubikey-personalization-gui
    yubikey-manager
    
    sops
  ];

  security.pam.services = {
    greetd.u2fAuth = true;
    sudo.u2fAuth = true;
    hyprlock.u2fAuth = true;
  };

  environment.etc = {
    # Crée /etc/u2f-mappings
    u2f-mappings = {
      text = ''
        ${config.user}:3GDSg/Qrk4K+lmgHzJ8eocSw7dZ8wbR5BXtX6MKSPGxly41oVi2jybNxq2IRmuBUfbdRTW+6eHANtaPu9OYpjA==,YI80SQYLYaghyd6IZRqsfPvpALmiPV6HKTd3K0WxpFA4qlSDv5LYM+8qek0/W6l9yRaPi+DSYGCzHgAa07j/TA==,es256,+presence%
      '';
      mode = "0644";
    };
  };
 
  security.pam.u2f = {
    enable = true;
    settings.origin = "pam://yubi";
    settings.appid = "pam://yubi";
    settings.authFile = "/etc/u2f-mappings";
    settings.cue = true;
  };

  programs.ssh.startAgent = lib.mkForce false;
  programs.ssh.extraConfig = ''
    AddKeysToAgent yes
  '';

  environment.shellInit = ''
    export GPG_TTY=$(tty)
  '';
}
