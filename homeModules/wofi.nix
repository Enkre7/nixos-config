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
      image_size = 32;
      insensitive = true;
      hide_scroll = true;
      no_actions = true;
      width = "35%";
      height = "45%";
      location = "center";
      key_expand = "Super_L";
      term = "kitty";
      columns = 2;
      matching = "fuzzy";
      filter_rate = 100;
      allow_markup = true;
      sort_order = "default";
    };
    
    style = ''
      * {
        background: none;
        border: none;
        color: ${stylix.base05};
        font-family: ${config.stylix.fonts.monospace.name};
        font-size: 14px;
        font-weight: 500;
      }
 
      window {
        margin: 0px;
        padding: 0px;
        background-color: ${stylix.base00};
        border-radius: 20px;
        border: 3px solid ${stylix.base0D};
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
        animation: fadeIn 0.2s ease-in-out;
        overflow: hidden;
      }

      @keyframes fadeIn {
        from {
          opacity: 0;
          transform: scale(0.95);
        }
        to {
          opacity: 1;
          transform: scale(1);
        }
      }

      #input {
        margin: 12px;
        padding: 12px 18px;
        border: 2px solid ${stylix.base0D};
        background-color: ${stylix.base01};
        border-radius: 15px;
        color: ${stylix.base05};
        font-size: 15px;
        transition: all 0.2s ease-in-out;
      }

      #input:focus {
        border-color: ${stylix.base0D};
        background-color: ${stylix.base02};
        box-shadow: 0 0 0 3px ${stylix.base0D}33;
      }

      #inner-box {
        margin: 8px 12px 12px 12px;
        border: none;
        background-color: transparent;
        border-radius: 15px;
      }

      #outer-box {
        margin: 0px;
        padding: 0px;
        border: none;
        background-color: transparent;
        border-radius: 20px;
      }

      #scroll {
        margin: 0px;
        border: none;
        background-color: transparent;
      }

      #text {
        margin: 0px 8px;
        padding: 0px;
        color: ${stylix.base05};
        font-size: 14px;
        transition: color 0.15s ease;
      }

      #entry {
        margin: 4px 0px;
        padding: 10px 12px;
        border-radius: 12px;
        background-color: transparent;
        transition: all 0.15s cubic-bezier(0.4, 0, 0.2, 1);
        outline: none;
      }

      #entry:selected {
        background-color: ${stylix.base0D};
        box-shadow: 0 2px 8px ${stylix.base0D}40;
        transform: translateX(2px);
      }

      #entry:selected #text {
        color: ${stylix.base00};
        font-weight: 600;
      }

      #entry:selected image {
        transition: transform 0.15s ease;
      }

      #entry:hover {
        background-color: ${stylix.base02};
      }

      #entry:selected:hover {
        background-color: ${stylix.base0D};
        opacity: 0.9;
      }

      image {
        margin-right: 8px;
        padding: 2px;
        border-radius: 8px;
        transition: all 0.15s ease;
      }

      #entry:selected image {
        background-color: ${stylix.base00}20;
      }

      @media (max-width: 1920px) {
        window {
          width: 40%;
        }
      }

      @media (max-width: 1366px) {
        window {
          width: 50%;
        }
        
        * {
          font-size: 13px;
        }
      }

      @media (max-width: 1024px) {
        window {
          width: 60%;
        }
        
        * {
          font-size: 12px;
        }
      }

      /* Scrollbar styling */
      scrollbar {
        background-color: transparent;
        width: 8px;
      }

      scrollbar slider {
        background-color: ${stylix.base03};
        border-radius: 4px;
        min-height: 20px;
      }

      scrollbar slider:hover {
        background-color: ${stylix.base04};
      }

      scrollbar slider:active {
        background-color: ${stylix.base0D};
      }

      #text:empty {
        color: ${stylix.base03};
      }

      #expander-box {
        background-color: transparent;
        padding: 4px 0px;
      }

      #expander {
        padding: 8px 12px;
        margin: 2px 0px;
        border-radius: 10px;
        background-color: ${stylix.base01};
        transition: all 0.15s ease;
      }

      #expander:hover {
        background-color: ${stylix.base02};
      }

      #expander:selected {
        background-color: ${stylix.base0D};
      }
    '';
  };
}
