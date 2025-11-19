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

      control-center-width = 400;
      control-center-height = 510;
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;

      notification-window-width = 300;
      notification-icon-size = 48;
      notification-body-image-height = 160;
      notification-body-image-width = 200;

      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;

      fit-to-screen = false;
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
          button-text = "Clear All";
        };
        dnd = {
          text = "Ne pas déranger";
        };
        label = {
          max-lines = 1;
          text = "Notifications";
        };
        mpris = {
          autohide = true;
        };
      };
      widgets = [
        "title"
        "mpris"
        "dnd"
        "notifications"
      ];
    };
    style = ''
      * {
        all: unset;
        font-family: JetBrainsMono Nerd Font Mono;
        font-weight: normal;
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      }

      /* === CONTROL CENTER === */
      .control-center {
        background: #${stylix.base00};
        border: 2px solid #${stylix.base0C};
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
        padding: 0;
      }

      .control-center-list {
        background: transparent;
        padding: 0;
      }

      .control-center-list-placeholder {
        opacity: 0.5;
        margin: 20px;
        color: #${stylix.base04};
      }

      /* === NOTIFICATION ROWS === */
      .notification-row {
        outline: none;
        margin: 8px;
        padding: 0;
        border-radius: 8px;
      }

      .control-center .notification-row:focus,
      .control-center .notification-row:hover {
        background: #${stylix.base01};
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
      }

      .notification {
        background: transparent;
        padding: 0;
        margin: 0;
      }

      /* === NOTIFICATION CONTENT === */
      .notification-content {
        background: #${stylix.base00};
        padding: 12px;
        border-radius: 8px;
        border: 2px solid #${stylix.base0D};
        margin: 0;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
      }

      .notification-default-action {
        margin: 0;
        padding: 0;
        border-radius: 8px;
      }

      .notification-default-action:hover {
        background: #${stylix.base01};
      }

      /* === CLOSE BUTTON === */
      .close-button {
        background: #${stylix.base08};
        color: #${stylix.base00};
        text-shadow: none;
        padding: 4px 8px;
        border-radius: 8px;
        margin-top: 8px;
        margin-right: 8px;
        min-width: 24px;
        min-height: 24px;
      }

      .close-button:hover {
        background: #${stylix.base09};
        transform: scale(1.1);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
      }

      /* === NOTIFICATION ACTIONS === */
      .notification-action {
        background: #${stylix.base01};
        border: 2px solid #${stylix.base0D};
        border-top: none;
        border-radius: 0 0 8px 8px;
        padding: 8px;
        margin: 0;
      }

      .notification-action:hover {
        background: #${stylix.base0D};
        color: #${stylix.base00};
      }

      .notification-action:first-child {
        border-bottom-left-radius: 8px;
      }

      .notification-action:last-child {
        border-bottom-right-radius: 8px;
      }

      /* === INLINE REPLY === */
      .inline-reply {
        margin-top: 8px;
      }

      .inline-reply-entry {
        background: #${stylix.base01};
        color: #${stylix.base05};
        caret-color: #${stylix.base0D};
        border: 2px solid #${stylix.base03};
        border-radius: 8px;
        padding: 8px;
        font-size: 14px;
      }

      .inline-reply-entry:focus {
        border-color: #${stylix.base0D};
        box-shadow: 0 0 0 2px rgba(${stylix.base0D}, 0.2);
      }

      .inline-reply-button {
        margin-left: 8px;
        background: #${stylix.base0D};
        border: none;
        border-radius: 8px;
        color: #${stylix.base00};
        padding: 8px 16px;
        font-weight: 600;
      }

      .inline-reply-button:disabled {
        background: #${stylix.base02};
        color: #${stylix.base04};
        opacity: 0.5;
      }

      .inline-reply-button:hover:not(:disabled) {
        background: #${stylix.base0E};
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      }

      /* === TEXT ELEMENTS === */
      .summary {
        font-size: 16px;
        font-weight: 700;
        color: #${stylix.base0D};
        margin-bottom: 4px;
      }

      .time {
        font-size: 13px;
        font-weight: 500;
        color: #${stylix.base04};
        margin-right: 8px;
        opacity: 0.8;
      }

      .body {
        font-size: 14px;
        font-weight: 400;
        color: #${stylix.base05};
        line-height: 1.5;
        margin-top: 4px;
      }

      .body-image {
        margin-top: 8px;
        background-color: #${stylix.base01};
        border-radius: 8px;
        overflow: hidden;
      }

      /* === WIDGETS === */
      .widget-title {
        color: #${stylix.base0D};
        background: #${stylix.base01};
        padding: 12px 16px;
        margin: 12px;
        font-size: 1.3rem;
        font-weight: 700;
        border-radius: 10px;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }

      .widget-title > button {
        font-size: 13px;
        color: #${stylix.base05};
        background: #${stylix.base02};
        padding: 6px 12px;
        border-radius: 8px;
        font-weight: 600;
      }

      .widget-title > button:hover {
        background: #${stylix.base08};
        color: #${stylix.base00};
        transform: scale(1.05);
      }

      /* === DND WIDGET === */
      .widget-dnd {
        background: #${stylix.base01};
        padding: 12px 16px;
        margin: 8px 12px;
        border-radius: 10px;
        font-size: 15px;
        font-weight: 600;
        color: #${stylix.base0B};
        display: flex;
        justify-content: space-between;
        align-items: center;
      }

      .widget-dnd > switch {
        border-radius: 16px;
        background: #${stylix.base02};
        min-width: 48px;
        min-height: 24px;
      }

      .widget-dnd > switch:checked {
        background: #${stylix.base08};
      }

      .widget-dnd > switch slider {
        background: #${stylix.base05};
        border-radius: 50%;
        margin: 2px;
        min-width: 20px;
        min-height: 20px;
      }

      .widget-dnd > switch:checked slider {
        background: #${stylix.base00};
      }

      /* === LABEL WIDGET === */
      .widget-label {
        margin: 8px 12px;
        padding: 8px 12px;
      }

      .widget-label > label {
        font-size: 0.95rem;
        color: #${stylix.base05};
        font-weight: 500;
      }

      /* === MPRIS WIDGET === */
      .widget-mpris {
        background: #${stylix.base01};
        color: #${stylix.base05};
        padding: 12px;
        margin: 8px 12px;
        border-radius: 10px;
      }

      .widget-mpris > box > button {
        border-radius: 8px;
        background: #${stylix.base02};
        padding: 8px;
        margin: 2px;
      }

      .widget-mpris > box > button:hover {
        background: #${stylix.base0D};
        color: #${stylix.base00};
        transform: scale(1.1);
      }

      .widget-mpris-player {
        padding: 8px;
        margin: 4px;
      }

      .widget-mpris-title {
        font-weight: 700;
        font-size: 0.95rem;
        color: #${stylix.base0D};
        margin-bottom: 4px;
      }

      .widget-mpris-subtitle {
        font-size: 0.8rem;
        color: #${stylix.base04};
      }

      /* === FLOATING NOTIFICATIONS === */
      .floating-notifications {
        background: transparent;
      }

      .blank-window {
        background: transparent;
      }

      /* === MENUBAR === */
      .widget-menubar > box > .menu-button-bar > button,
      .topbar-buttons > button {
        border: none;
        background: transparent;
        padding: 8px;
        border-radius: 8px;
      }

      .widget-menubar > box > .menu-button-bar > button:hover,
      .topbar-buttons > button:hover {
        background: #${stylix.base02};
      }
    '';
  };
}
