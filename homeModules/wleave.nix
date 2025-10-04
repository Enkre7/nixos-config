{ config, pkgs, ... }:

let
  stylix = config.lib.stylix.colors.withHashtag;
  
  osConfig = config.home.sessionVariables.XDG_CURRENT_DESKTOP or "";
  isHyprland = osConfig == "Hyprland";
  isSway = osConfig == "sway";
  isNiri = osConfig == "niri";

  logoutCommand = 
    if isHyprland then "hyprctl dispatch exit 0"
    else if isSway then "swaymsg exit"
    else if isNiri then "niri msg action quit"
    else "hyprctl dispatch exit 0";
in
{
  home.packages = with pkgs; [ wleave ];
  
  xdg.configFile."wleave/config.toml".text = ''
    [general]
    border-radius = 20
    margin-top = 0
    margin-bottom = 0
    margin-left = 0
    margin-right = 0
    
    [buttons.lock]
    label = "Lock"
    command = "hyprlock"
    icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus/symbolic/status/changes-prevent-symbolic.svg"
    
    [buttons.logout]
    label = "Logout"
    command = "${logoutCommand}"
    icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus/symbolic/actions/system-log-out-symbolic.svg"
    
    [buttons.suspend]
    label = "Suspend"
    command = "hyprlock && systemctl suspend"
    icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus/symbolic/actions/system-suspend-symbolic.svg"
    
    [buttons.hibernate]
    label = "Hibernate"
    command = "systemctl hibernate"
    icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus/symbolic/actions/system-suspend-hibernate-symbolic.svg"
    
    [buttons.reboot]
    label = "Reboot"
    command = "systemctl reboot"
    icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus/symbolic/actions/system-reboot-symbolic.svg"
    
    [buttons.poweroff]
    label = "Shutdown"
    command = "systemctl poweroff"
    icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus/symbolic/actions/system-shutdown-symbolic.svg"
  '';
  
  xdg.configFile."wleave/style.css".text = ''
    * {
      font-family: "${config.stylix.fonts.monospace.name}";
      font-size: 14px;
    }
    
    window {
      background-color: rgba(0, 0, 0, 0.75);
    }
    
    button {
      background-color: ${stylix.base01};
      color: ${stylix.base05};
      border: 2px solid ${stylix.base03};
      border-radius: 20px;
      padding: 20px;
      margin: 10px;
      min-width: 150px;
      min-height: 150px;
      transition: all 0.3s ease;
    }
    
    button:hover {
      background-color: ${stylix.base02};
      border-color: ${stylix.base0D};
      color: ${stylix.base0D};
      transform: scale(1.05);
    }
    
    button:focus {
      background-color: ${stylix.base02};
      border-color: ${stylix.base0D};
      outline: none;
    }
    
    button label {
      color: inherit;
      font-weight: bold;
      margin-top: 10px;
    }
    
    button image {
      color: inherit;
      margin-bottom: 10px;
    }
    
    #lock:hover {
      border-color: ${stylix.base0A};
      color: ${stylix.base0A};
    }
    
    #logout:hover {
      border-color: ${stylix.base0B};
      color: ${stylix.base0B};
    }
    
    #suspend:hover {
      border-color: ${stylix.base0C};
      color: ${stylix.base0C};
    }
    
    #hibernate:hover {
      border-color: ${stylix.base0E};
      color: ${stylix.base0E};
    }
    
    #reboot:hover {
      border-color: ${stylix.base09};
      color: ${stylix.base09};
    }
    
    #poweroff:hover {
      border-color: ${stylix.base08};
      color: ${stylix.base08};
    }
  '';
}
