{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
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
      vscodevim.vim
      yzhang.markdown-all-in-one
      streetsidesoftware.code-spell-checker
    ];
    userSettings = {
      "redhat.telemetry.enabled" = "false";
    };
  };
}
