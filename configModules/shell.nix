{ pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh bash ];
  programs.zsh.enable = true; # Enable nix-zsh-completions plugin

  services.journald = {
    extraConfig = ''
      MaxRetentionSec=1month
      SystemMaxUse=1G
      SystemMaxFileSize=100M
    '';
  };
}
