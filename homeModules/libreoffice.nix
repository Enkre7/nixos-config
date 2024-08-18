{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.fr-any
  ];
}
