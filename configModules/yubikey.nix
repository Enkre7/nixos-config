{ pkgs, ...}:

{
  # Install yubikey packages
  services.yubikey-agent.enable = true;
  programs.yubikey-touch-detector.enable = true;
  services.pcscd.enable = true;  
  services.udev.packages = with pkgs; [ yubikey-personalization ];
  environment.systemPackages = with pkgs; [ yubikey-personalization-gui yubikey-manager yubikey-manager-qt ];

  security.pam.yubico = {
    enable = true;
    id = "42";
    mode = "client";
  };

  # Yubikey host authentification
  programs.ssh.startAgent = true;
  # Need to create an authorization mapping file for the user (https://nixos.wiki/wiki/Yubikey#pam_u2f)
  security.pam = {
    u2f.enable = true;
    u2f.settings.cue = true;
    u2f.control = "sufficient";
    services = {
      greetd.u2fAuth = true;
      sudo.u2fAuth = true;
      hyprlock.u2fAuth = true;
    };
  };
}
