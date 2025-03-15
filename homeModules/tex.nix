{ pkgs, ... }:

{
  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit (tpkgs)
        collection-fontsrecommended
        collection-latexextra
        collection-langfrench
        latexmk
      ;
    };
  };

  programs.vscode = {
    profiles.default.extensions = with pkgs.vscode-extensions; [
      james-yu.latex-workshop
    ];

    userSettings = {
      "latex-workshop.latex.tools" = [
        {
          "name" = "latexmk";
          "command" = "latexmk";
          "args" = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "-pdf"
            "-outdir=%OUTDIR%"
            "%DOC%"
          ];
        }
      ];
      "latex-workshop.latex.recipes" = [
        {
          "name" = "latexmk 🔃";
          "tools" = [ "latexmk" ];
        }
      ];
      "latex-workshop.view.pdf.viewer" = "tab";
    };
  };
}
