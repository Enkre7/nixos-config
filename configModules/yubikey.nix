{ config, pkgs, ...}:

{
  # Install yubikey packages
  services.yubikey-agent.enable = true;
  programs.yubikey-touch-detector.enable = true;
  
  services.pcscd.enable = true;  
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
  environment.systemPackages = with pkgs; [
    yubico-piv-tool
    yubikey-personalization
    yubikey-personalization-gui
    yubikey-manager
    yubioath-flutter
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
    # Format: "<username>:<KeyHandle>,<UserKey>,<CoseType>,<Options>"
    settings.authFile = "/etc/u2f_mapping";
    settings.control = "required";
    settings.cue = true;
  };

  # Locking the screen when a Yubikey is unplugged (from nixos documentation)
  /*services.udev.extraRules = ''
      ACTION=="remove",\
       ENV{ID_BUS}=="usb",\
       ENV{ID_MODEL_ID}=="0407",\
       ENV{ID_VENDOR_ID}=="1050",\
       ENV{ID_VENDOR}=="Yubico",\
       RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';*/
}
