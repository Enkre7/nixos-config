{ config, pkgs, lib, ...}:

{
  # Install yubikey packages
  services.yubikey-agent.enable = true;
  programs.yubikey-touch-detector.enable = true;
  
  services.pcscd.enable = true;  
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host gnupg ];
  environment.systemPackages = with pkgs; [
    yubico-piv-tool
    yubikey-personalization
    yubikey-personalization-gui
    yubikey-manager
    age
    age-plugin-yubikey
    sops
    ssh-to-age
  ];

  # Yubikey host authentification
  # Need to create an authorization mapping file for the user (https://nixos.wiki/wiki/Yubikey#pam_u2f)
  security.pam.services = {
    greetd.u2fAuth = true;
    sudo.u2fAuth = true;
    hyprlock.u2fAuth = true;
  };

  environment.etc = {
    # Creates /etc/u2f-mappings
    u2f-mappings = {
      text = ''
        ${config.user}:3GDSg/Qrk4K+lmgHzJ8eocSw7dZ8wbR5BXtX6MKSPGxly41oVi2jybNxq2IRmuBUfbdRTW+6eHANtaPu9OYpjA==,YI80SQYLYaghyd6IZRqsfPvpALmiPV6HKTd3K0WxpFA4qlSDv5LYM+8qek0/W6l9yRaPi+DSYGCzHgAa07j/TA==,es256,+presence%
      '';
      # The UNIX file mode bits
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

  # SSH config for  age-plugin-yubikey
  programs.ssh.startAgent = true;
  
  programs.ssh.extraConfig = ''
    AddKeysToAgent yes
  '';

  environment.sessionVariables = {
    AGE_PLUGIN_YUBIKEY_CONFIRM = "false"; # Désactiver la confirmation pour chaque opération (optionnel)
  };
}
