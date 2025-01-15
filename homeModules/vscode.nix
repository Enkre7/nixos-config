{ pkgs, config, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools-extension-pack
      esbenp.prettier-vscode
      davidanson.vscode-markdownlint
      ms-ceintl.vscode-language-pack-fr
      ms-azuretools.vscode-docker
      jnoortheen.nix-ide
      bbenoist.nix
      ecmel.vscode-html-css
      christian-kohler.path-intellisense
      redhat.vscode-yaml
      redhat.vscode-xml
      zainchen.json
      redhat.ansible
      pkief.material-icon-theme
      ms-vscode.powershell
      ms-vscode-remote.remote-containers
      ms-python.python
      ms-kubernetes-tools.vscode-kubernetes-tools
      #vscodevim.vim
      yzhang.markdown-all-in-one
      james-yu.latex-workshop
      streetsidesoftware.code-spell-checker
    ];
    userSettings = {
      "redhat.telemetry.enabled" = "false";
      "files.autoSave" = "off";

      "cSpell.language" = "en,fr";
     
      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
      "nix.serverSettings.nixd" = {
        "formatting.command" = [ "nixfmt" ]; # or alejandra or nixpkgs-fmt
      };
      "options" = {
        "nixos.expr" = "(builtins.getFlake ${config.flakePath}).nixosConfigurations.${config.hostname}.options";
        "home_manager.expr" = "(builtins.getFlake ${config.flakePath}).homeConfigurations.${config.hostname}.options";
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/plain" = "codium";
    "text/html" = "codium";
    "application/javascript" = "codium";
    "application/json" = "codium";
    "application/x-python-code" = "codium";
    "application/xml" = "codium";
    "text/x-shellscript" = "codium";
    "text/x-csrc" = "codium";
    "text/x-c++src" = "codium";
    "text/markdown" = "codium";
    "text/x-nix" = "codium";
  };
}
