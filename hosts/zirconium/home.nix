{ config, pkgs, lib, inputs, ... }:

{
  imports = [
  ];

  home.username = "enkre";
  home.homeDirectory = "/home/enkre";
  home.stateVersion = "23.11";

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
    };

    git = {
      enable = true;
      userName  = "Enkre7";
      userEmail = "victor.mairot@proton.me";
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos";
      };
    };

    kitty = {
      enable = true;
      settings = {
        copy_on_select = true;
        clipboard_control = "write-clipboard read-clipboard write-primary read-primary";
      };
    };
  };

  nixpkgs.config.allowUnfreePredicate = _: true;
  home.packages = with pkgs; [
    vscode-with-extensions
    nextcloud-client
    bitwarden
    yubikey-agent
    webcord
    wireshark
    ffmpeg-full
  #games
    steam
    steam-run
    lutris
    heroic
    bottles
    protonup
  ];

  home.file = {
  };

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };

  programs.home-manager.enable = true;
}
