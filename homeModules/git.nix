{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName  = config.gitUsername;
    userEmail = config.gitEmail;
    extraConfig = {    
      init.defaultBranch = "main";
      safe.directory = [ config.flakePath  "/home/${config.user}/.dotfiles" ];  
      push.autoSetupRemote = true;
      diff.tool = "meld"; 
      difftool = {
        prompt = false;
        cmd = "meld $LOCAL $REMOTE";
      };
      merge.tool = "meld";
      mergetool.cmd = "meld $LOCAL $MERGED $REMOTE --output $MERGED";
    };
  };
  
  # git diff/merge tool
  home.packages = with pkgs; [ meld ];
}
