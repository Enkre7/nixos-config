{ config, pkgs, lib, ...}:

let
  homeDirectory =
    if pkgs.stdenv.isLinux then "/home/${config.user}" else "/Users/${config.user}";
in
{
  services.pcscd.enable = true;  
  services.yubikey-agent.enable = true;
  programs.yubikey-touch-detector.enable = true;

  services.udev.packages = with pkgs; [ yubikey-personalization ];

  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    yubioath-flutter
  ];

  security.pam = {
    u2f = {
      enable = true;
      control = "sufficient";
      #settings.origin = "pam://yubi";
      #settings.appid = "pam://yubi";
      #settings.authFile = "/etc/u2f-mappings";
      settings.cue = true;
      settings.authFile = "${homeDirectory}/.config/Yubico/u2f_keys";
    };
    services = {
      login.u2fAuth = true;
      greetd.u2fAuth = true;
      sudo.u2fAuth = true;
      hyprlock.u2fAuth = true;
      sshd.u2fAuth = true;
      polkit-1.u2fAuth = true;
      su.u2fAuth = true;
      passwd.u2fAuth = true;
    };
  };
  
  system.activationScripts.yubikeydirs = ''
    mkdir -p ${homeDirectory}/.config/Yubico
    chown ${config.user}:users ${homeDirectory}/.config/Yubico
    chmod 700 ${homeDirectory}/.config/Yubico
  '';

  #environment.etc = {
    # create /etc/u2f-mappings
   # u2f-mappings = {
    #  text = ''
     #   ${config.user}:3GDSg/Qrk4K+lmgHzJ8eocSw7dZ8wbR5BXtX6MKSPGxly41oVi2jybNxq2IRmuBUfbdRTW+6eHANtaPu9OYpjA==,YI80SQYLYaghyd6IZRqsfPvpALmiPV6HKTd3K0WxpFA4qlSDv5LYM+8qek0/W6l9yRaPi+DSYGCzHgAa07j/TA==,es256,+presence%
      #'';
      #mode = "0644";
    #};
  #};
}
