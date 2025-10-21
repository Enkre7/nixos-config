{ config, pkgs, lib, ... }:

let
  homeDirectory = "/home/${config.user}";
in
{
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  
  programs.ssh.startAgent = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    yubikey-personalization
    gnupg
    pinentry-gtk2
    sops
    ssh-to-pgp
    pam_u2f
  ];

  security.pam = {
    u2f = {
      enable = true;
      control = "sufficient";
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
}
