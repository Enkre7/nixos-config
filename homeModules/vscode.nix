{ pkgs, config, ... }:

{
  stylix.targets.vscode.profileNames = [ "${config.user}" ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
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
      pkief.material-icon-theme
      ms-vscode.powershell
      ms-vscode-remote.remote-containers
      eamodio.gitlens
      yzhang.markdown-all-in-one
      james-yu.latex-workshop
      streetsidesoftware.code-spell-checker
      ritwickdey.liveserver
      github.codespaces
    ];
    profiles.default.userSettings = {
      "window.zoomLevel" = 0;
      "workbench.startupEditor" = "newUntitledFile";
      "workbench.editor.enablePreview" = false;
      "workbench.preferredDarkColorTheme" = "Default Dark+";
      "workbench.preferredLightColorTheme" = "Default Light+";
      "window.autoDetectColorScheme" = true;
      "workbench.iconTheme" = "material-icon-theme";
      "editor.tabSize" = 2;
      "editor.insertSpaces" = true;
      "editor.detectIndentation" = true;
      "editor.minimap.enabled" = true;
      "editor.wordWrap" = "off";
      "editor.renderWhitespace" = "boundary";
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.formatOnSave" = true;
      "editor.linkedEditing" = true;
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = true;
      "editor.suggest.showKeywords" = true;
      "editor.suggestSelection" = "first";
      "editor.inlineSuggest.enabled" = true;
      "redhat.telemetry.enabled" = false;
      "files.autoSave" = "off";
      "cSpell.language" = "en;fr";
      "security.allowedUNCHosts" = [];
      "git.terminalAuthentication" = true;
      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
      "nix.serverSettings.nixd" = {
        "formatting.command" = [ "nixfmt" ];
      };
      "options" = {
        "nixos.expr" = "(builtins.getFlake ${config.flakePath}).nixosConfigurations.${config.hostname}.options";
        "home_manager.expr" = "(builtins.getFlake ${config.flakePath}).homeConfigurations.${config.hostname}.options";
      };
      "terminal.integrated.defaultProfile.linux" = "bash";
      "terminal.integrated.cursorBlinking" = true;
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;
      "files.exclude" = {
        "**/.git" = true;
        "**/.DS_Store" = true;
        "**/node_modules" = true;
        "**/.direnv" = true;
        "**/result" = true;
      };
      "search.exclude" = {
        "**/node_modules" = true;
        "**/bower_components" = true;
        "**/.direnv" = true;
        "**/result" = true;
      };
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "git.autofetch" = true;
      "telemetry.telemetryLevel" = "off";
      "update.mode" = "none";
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "[nix]" = {
        "editor.tabSize" = 2;
        "editor.formatOnSave" = true;
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "breadcrumbs.enabled" = true;
      "workbench.list.smoothScrolling" = true;
      "editor.smoothScrolling" = true;
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/plain" = "codium.desktop";
    "text/html" = "codium.desktop";
    "text/css" = "codium.desktop";
    "application/javascript" = "codium.desktop";
    "application/typescript" = "codium.desktop";
    "application/json" = "codium.desktop";
    "application/x-python-code" = "codium.desktop";
    "application/xml" = "codium.desktop";
    "text/x-shellscript" = "codium.desktop";
    "text/x-csrc" = "codium.desktop";
    "text/x-c++src" = "codium.desktop";
    "text/markdown" = "codium.desktop";
    "text/x-nix" = "codium.desktop";
    "application/xhtml+xml" = "codium.desktop";
    "application/x-sh" = "codium.desktop";
  };

  home.sessionVariables = {
    GNOME_KEYRING_CONTROL = "/run/user/1000/keyring";
  };
}
