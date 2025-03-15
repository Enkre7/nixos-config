{ pkgs, ... }:

{
  programs.texlive = {
    enable = true;
    packageSet = pkgs.texlive.combined.scheme-full;
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
