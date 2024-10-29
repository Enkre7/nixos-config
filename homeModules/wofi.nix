{ config, pkgs, ... }:
let
  stylix = config.lib.stylix.colors.withHashtag;
in
{
  programs.wofi = {
    enable = true;
    package = pkgs.wofi;
    settings = {
      prompt = "";
      mode = "drun";
      allow_images = true;
    };
    style = ''
      * {
        color: ${stylix.base07};
        font-family: "JetbrainsMono Nerd Font Mono";
        font-size: 14px;
        border-radius: 20px;
      }
 
      window {
        margin: 0px;
        background-color: ${stylix.base02};
        border-radius: 30px;
        border: 2px solid ${stylix.base0E};;
      }

      #input {
        margin: 5px;
        border: none;
        background-color: ${stylix.base0D};
        border-radius: 30px;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: ${stylix.base02};
        border-radius: 30px;
      }

      #outer-box {
        margin: 15px;
        border: none;
        background-color: ${stylix.base02};
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
      }

      #entry:selected {
        background-color: ${stylix.base0D};
        border-radius: 20px;
        outline: none;
      }

      #entry:unselected {
        background-color: ${stylix.base02};
        border-radius: 20px;
        outline: none;
      }
    '';
  };
}
