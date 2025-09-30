{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    fzf
    exfat
  ];
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ssh = "TERM='xterm-256color' kitty +kitten ssh";
      scanfile = "scanimage --format=jpeg --output-file=/home/${config.user}/Téléchargements/scan.jpeg";
      ll = "sudo ls -laRh";
      fman = "compgen -c | fzf | xargs man";
      fetch = "${pkgs.fastfetch}/bin/fastfetch --config examples/10.jsonc";
      #rebuild = "sudo nixos-rebuild switch --flake ${config.flakePath}#${config.hostname}";
      rebuild = "nh os switch --hostname ${config.hostname} && fc-cache -r";
      push = "sudo chown -R ${config.user}:users ${config.flakePath} && sudo chmod -R +x ${config.flakePath} && cd ${config.flakePath} && git add . && git commit -m 'Automatic commit' && git push";
      pull = "cd ${config.flakePath} && git pull";
      #update = "cd ${config.flakePath} && sudo nix flake update";
      update = "nh os switch --update --hostname ${config.hostname}";
      update-firmware = "fwupdmgr refresh --force && fwupdmgr get-updates && fwupdmgr update";
      list-gen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      clean-gen = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations";
      rollback-gen = "sudo nixos-rebuild --rollback switch --flake ${config.flakePath}#${config.hostname}";
      switch-gen = "sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation";
      clean-boot = "sudo /run/current-system/bin/switch-to-configuration boot";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    
    oh-my-zsh = {
      enable = true;
      theme = "strug"; # juanghurtado mh
      plugins = [
        "ansible"
        "sudo"
        "git"
        "history"
      ];
    };
  };

  programs.bash = {
    shellAliases = {
      ssh = "TERM='xterm-256color' kitty +kitten ssh";
      scanfile = "scanimage --format=jpeg --output-file=/home/${config.user}/Téléchargements/scan.jpeg";
      ll = "sudo ls -laRh";
      fman = "compgen -c | fzf | xargs man";
      fetch = "${pkgs.fastfetch}/bin/fastfetch --config examples/10.jsonc";
      #rebuild = "sudo nixos-rebuild switch --flake ${config.flakePath}#${config.hostname}";
      rebuild = "nh os switch --hostname ${config.hostname} && fc-cache -r";
      push = "sudo chown -R ${config.user}:users ${config.flakePath} && sudo chmod -R +x ${config.flakePath} && cd ${config.flakePath} && git add . && git commit -m 'Automatic commit' && git push";
      pull = "cd ${config.flakePath} && git pull";
      #update = "cd ${config.flakePath} && sudo nix flake update";
      update = "nh os switch --update --hostname ${config.hostname}";
      update-firmware = "fwupdmgr refresh --force && fwupdmgr get-updates && fwupdmgr update";
      list-gen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      clean-gen = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations";
      rollback-gen = "sudo nixos-rebuild --rollback switch --flake ${config.flakePath}#${config.hostname}";
      switch-gen = "sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation";
      clean-boot = "sudo /run/current-system/bin/switch-to-configuration boot";
    };
  };
}
