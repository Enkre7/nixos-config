{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name  = config.gitUsername;
      user.email = config.gitEmail;
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
      credential.helper = "store";
      url."https://github.com/".insteadOf = "git@github.com:";
    };
  };
  
  # git diff/merge tool
  home.packages = with pkgs; [ meld ];
}
