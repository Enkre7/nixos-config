{ config, ... }:

let
  stylix = config.lib.stylix.colors;
in
{
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      notification-icon-size = 64;
      notification-body-image-height = 50;
      notification-body-image-width = 100;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = false;
      control-center-width = 400;
      control-center-height = 600;
      notification-window-width = 300;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "󰆴 Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        label = {
          max-lines = 1;
          text = "Notifications";
        };
        mpris = {
          image-size = 96;
          image-radius = 7;
        };
        volume = {
          label = "󰕾";
        };
        backlight = {
          label = "󰃟";
        };
      };
      widgets = [
        "title"
        "mpris"
        #"volume"
        #"backlight"
        "dnd"
        "notifications"
      ];
    };
    style = ''
      * {
        font-family: JetBrainsMono Nerd Font Mono;
        font-weight: normal;
      }
      .control-center .notification-row:focus,
      .control-center .notification-row:hover {
        opacity: 0.9;
        background: #${stylix.base00}
      }
      .notification-row {
        outline: none;
        margin: 10px;
        padding: 0;
      }
      .notification {
        background: transparent;
        background-color: transparent;
        padding: 0;
        margin: 0px;
      }
      .notification-content {
        background: #${stylix.base00};
        padding: 10px;
        border-radius: 5px;
        border: 2px solid #${stylix.base0D};
        margin: 0;
      }
      .notification-default-action {
        margin: 0;
        padding: 0;
        border-radius: 5px;
      }
      .close-button {
        background: #${stylix.base08};
        color: #${stylix.base00};
        text-shadow: none;
        padding: 0;
        border-radius: 5px;
        margin-top: 5px;
        margin-right: 5px;
      }
      .close-button:hover {
        box-shadow: none;
        background: #${stylix.base0D};
        transition: all .15s ease-in-out;
        border: none
      }
      .notification-action {
        border: 2px solid #${stylix.base0D};
        border-top: none;
        border-radius: 5px;
      }
      .notification-default-action:hover,
      .notification-action:hover {
        color: #${stylix.base0B};
        background: #${stylix.base0B}
      }
      .notification-default-action {
        border-radius: 5px;
        margin: 0px;
      }
      .notification-default-action:not(:only-child) {
        border-bottom-left-radius: 7px;
        border-bottom-right-radius: 7px
      }
      .notification-action:first-child {
        border-bottom-left-radius: 10px;
        background: #${stylix.base00}
      }
      .notification-action:last-child {
        border-bottom-right-radius: 10px;
        background: #${stylix.base00}
      }
      .inline-reply {
        margin-top: 8px
      }
      .inline-reply-entry {
        background: #${stylix.base00};
        color: #${stylix.base05};
        caret-color: #${stylix.base05};
        border: 1px solid #${stylix.base09};
        border-radius: 5px
      }
      .inline-reply-button {
        margin-left: 4px;
        background: #${stylix.base00};
        border: 1px solid #${stylix.base09};
        border-radius: 5px;
        color: #${stylix.base05}
      }
      .inline-reply-button:disabled {
        background: initial;
        color: #${stylix.base03};
        border: 1px solid transparent
      }
      .inline-reply-button:hover {
        background: #${stylix.base00}
      }
      .body-image {
        margin-top: 6px;
        background-color: #${stylix.base05};
        border-radius: 5px
      }
      .summary {
        font-size: 16px;
        font-weight: 700;
        background: transparent;
        color: rgba(158, 206, 106, 1);
        text-shadow: none
      }
      .time {
        font-size: 16px;
        font-weight: 700;
        background: transparent;
        color: #${stylix.base05};
        text-shadow: none;
        margin-right: 18px
      }
      .body {
        font-size: 15px;
        font-weight: 400;
        background: transparent;
        color: #${stylix.base05};
        text-shadow: none
      }
      .control-center {
        background: #${stylix.base00};
        border: 2px solid #${stylix.base0C};
        border-radius: 5px;
      }
      .control-center-list {
        background: transparent
      }
      .control-center-list-placeholder {
        opacity: .5
      }
      .floating-notifications {
        background: transparent
      }
      .blank-window {
        background: alpha(black, 0)
      }
      .widget-title {
        color: #${stylix.base0B};
        background: #${stylix.base00};
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        font-size: 1.5rem;
        border-radius: 5px;
      }
      .widget-title>button {
        font-size: 1rem;
        color: #${stylix.base05};
        text-shadow: none;
        background: #${stylix.base00};
        box-shadow: none;
        border-radius: 5px;
      }
      .widget-title>button:hover {
        background: #${stylix.base08};
        color: #${stylix.base00};
      }
      .widget-dnd {
        background: #${stylix.base00};
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        border-radius: 5px;
        font-size: large;
        color: #${stylix.base0B};
      }
      .widget-dnd>switch {
        border-radius: 5px;
        /* border: 1px solid #${stylix.base0B}; */
        background: #${stylix.base0B};
      }
      .widget-dnd>switch:checked {
        background: #${stylix.base08};
        border: 1px solid #${stylix.base08};
      }
      .widget-dnd>switch slider {
        background: #${stylix.base00};
        border-radius: 5px
      }
      .widget-dnd>switch:checked slider {
        background: #${stylix.base00};
        border-radius: 5px
      }
      .widget-label {
          margin: 10px 10px 5px 10px;
      }
      .widget-label>label {
        font-size: 1rem;
        color: #${stylix.base05};
      }
      .widget-mpris {
        color: #${stylix.base05};
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        border-radius: 5px;
      }
      .widget-mpris > box > button {
        border-radius: 5px;
      }
      .widget-mpris-player {
        padding: 5px 10px;
        margin: 10px
      }
      .widget-mpris-title {
        font-weight: 700;
        font-size: 1.25rem
      }
      .widget-mpris-subtitle {
        font-size: 1.1rem
      }
      .widget-menubar>box>.menu-button-bar>button {
        border: none;
        background: transparent
      }
      .topbar-buttons>button {
        border: none;
        background: transparent
      }
      .widget-volume {
        background: #${stylix.base01};
        padding: 5px;
        margin: 10px 10px 5px 10px;
        border-radius: 5px;
        font-size: x-large;
        color: #${stylix.base05};
      }
      .widget-volume>box>button {
        background: #${stylix.base0B};
        border: none
      }
      .per-app-volume {
        background-color: #${stylix.base00};
        padding: 4px 8px 8px;
        margin: 0 8px 8px;
        border-radius: 5px;
      }
      .widget-backlight {
        background: #${stylix.base01};
        padding: 5px;
        margin: 10px 10px 5px 10px;
        border-radius: 5px;
        font-size: x-large;
        color: #${stylix.base05}
      }
    '';
  };
}
