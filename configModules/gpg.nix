{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnupg
    pinentry-curses
    pinentry-qt
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };

  services.pcscd.enable = true;
  
  environment.shellInit = ''
    export GPG_TTY=$(tty)
  '';
}
