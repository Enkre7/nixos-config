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
  
  home.activation.setupGitSSH = lib.hm.dag.entryAfter ["writeBoundary"] ''
    SETUP_FLAG="$HOME/.ssh/.github-setup-done"
    
    if [ ! -f "$SETUP_FLAG" ]; then
      if [ ! -f $HOME/.ssh/github ]; then
        $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -C "${config.gitEmail}" -f $HOME/.ssh/github -N ""
        $DRY_RUN_CMD chmod 600 $HOME/.ssh/github
        $DRY_RUN_CMD chmod 644 $HOME/.ssh/github.pub
        $DRY_RUN_CMD cd ${config.flakePath} && git remote set-url origin git@github.com:Enkre7/nixos-config.git
      fi
      
      if [ -f $HOME/.ssh/github.pub ]; then
        # Console output
        echo ""
        echo "GitHub SSH key generated"
        echo "Run: cat ~/.ssh/github.pub in terminal and setup it in Github."
        echo ""
        
        # Visual notification
        $DRY_RUN_CMD ${pkgs.libnotify}/bin/notify-send "GitHub SSH Key" "Key generated. Run: cat ~/.ssh/github.pub in terminal and setup it in Github." -u critical -t 10000
      fi
      
      touch "$SETUP_FLAG"
    fi
  '';
  
  home.file.".ssh/config.d/github".text = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile ~/.ssh/github
      IdentitiesOnly yes
      AddKeysToAgent yes
  '';
  
  home.packages = with pkgs; [ meld ];
}
