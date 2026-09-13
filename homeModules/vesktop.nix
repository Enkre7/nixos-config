{ config, pkgs, ... }:

let
  c = config.lib.stylix.colors;
in
{
  home.packages = with pkgs; [ vesktop ];

  xdg.configFile."vesktop/settings/settings.json".text = builtins.toJSON {
    autoUpdate = false;
    autoUpdateNotification = true;
    notifyAboutUpdates = true;
    useQuickCss = true;
    themeLinks = [ ];
    enabledThemes = [ ];
    eagerPatches = false;
    enableReactDevtools = false;
    frameless = false;
    transparent = false;
    winCtrlQ = false;
    disableMinSize = false;
    winNativeTitleBar = false;
    windowsMaterial = "none";

    plugins = {
      BadgeAPI.enabled = true;
      CommandsAPI.enabled = true;
      ContextMenuAPI.enabled = true;
      MessageAccessoriesAPI.enabled = true;
      MessageEventsAPI.enabled = true;
      MessageUpdaterAPI.enabled = true;
      NoticesAPI.enabled = true;
      UserSettingsAPI.enabled = true;

      CrashHandler.enabled = true;
      SupportHelper.enabled = true;

      NoTrack = {
        enabled = true;
        disableAnalytics = true;
      };

      Settings = {
        enabled = true;
        settingsLocation = "aboveActivity";
        includeVencordInfoWhenCopying = true;
      };

      BetterUploadButton.enabled = true;
      ConcatenatedComponentExtractor.enabled = true;
      DisableDeepLinks.enabled = true;
      WebScreenShareFixes.enabled = true;
      WhoReacted.enabled = true;
      YoutubeAdblock.enabled = true;
      petpet.enabled = true;

      CallTimer = {
        enabled = true;
        format = "human";
      };

      FakeNitro = {
        enabled = true;
        enableEmojiBypass = true;
        emojiSize = 48;
        transformEmojis = true;
        enableStickerBypass = true;
        stickerSize = 160;
        transformStickers = true;
        transformCompoundSentence = false;
        enableStreamQualityBypass = true;
        useHyperLinks = true;
        hyperLinkText = "{{NAME}}";
      };

      FakeProfileThemes = {
        enabled = true;
        nitroFirst = true;
      };

      MessageLogger = {
        enabled = true;
        deleteStyle = "text";
        ignoreBots = false;
        ignoreSelf = false;
        ignoreUsers = "";
        ignoreChannels = "";
        ignoreGuilds = "";
        logDeletedAttachments = true;
        collapseDeleted = false;
      };

      RoleColorEverywhere = {
        enabled = true;
        chatMentions = true;
        memberList = true;
        voiceUsers = true;
        reactorsList = true;
        pollResults = true;
        colorChatMessages = false;
      };

      WebKeybinds = {
        enabled = true;
        showNavigationButtons = true;
        overrideCommonKeybinds = true;
      };
    };

    notifications = {
      timeout = 5000;
      position = "bottom-right";
      useNative = "not-focused";
      logLimit = 50;
    };

    cloud = {
      authenticated = true;
      url = "https://api.vencord.dev/";
      settingsSync = true;
    };

    uiElements = {
      chatBarButtons = { };
      messagePopoverButtons = { };
    };
  };

  xdg.configFile."vesktop/settings/quickCss.css".text = ''
    :root {
      --background-primary: #${c.base00};
      --background-secondary: #${c.base01};
      --background-secondary-alt: #${c.base01};
      --background-tertiary: #${c.base00};
      --background-accent: #${c.base02};
      --background-floating: #${c.base01};
      --background-modifier-hover: #${c.base02};
      --background-modifier-active: #${c.base02};
      --background-modifier-selected: #${c.base02};
      --channeltextarea-background: #${c.base01};
      --text-normal: #${c.base05};
      --text-muted: #${c.base04};
      --text-link: #${c.base0D};
      --header-primary: #${c.base05};
      --header-secondary: #${c.base04};
      --interactive-normal: #${c.base04};
      --interactive-hover: #${c.base05};
      --interactive-active: #${c.base05};
      --interactive-muted: #${c.base03};
      --brand-experiment: #${c.base0D};
      --brand-experiment-560: #${c.base0D};
      --scrollbar-thin-thumb: #${c.base02};
      --scrollbar-auto-thumb: #${c.base02};
      --scrollbar-auto-track: #${c.base00};
    }

    .theme-dark, .theme-light {
      --background-primary: #${c.base00};
      --background-secondary: #${c.base01};
      --background-tertiary: #${c.base00};
    }
  '';
}
