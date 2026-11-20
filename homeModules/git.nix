{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = config.gitUsername;
      user.email = config.gitEmail;
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      safe.directory = [ config.flakePath "/home/${config.user}/.dotfiles" ];
      
      diff.tool = "meld"; 
      difftool = {
        prompt = false;
        cmd = "meld $LOCAL $REMOTE";
      };
      merge.tool = "meld";
      mergetool.cmd = "meld $LOCAL $MERGED $REMOTE --output $MERGED";
    };
  };
  
  # Clés SSH GitHub (Bitwarden + YubiKey) : homeModules/ssh.nix.
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.git_protocol = "https";
  };

  home.packages = with pkgs; [ meld ];
}
