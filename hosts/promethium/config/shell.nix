{ pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh bash ];
  programs.zsh.enable = true; # Enable nix-zsh-completions plugin
}
