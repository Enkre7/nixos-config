{ config, pkgs, inputs, lib, ... }:

{
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      SearchBar = "unified"; # alternative: "separate"
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;
      AutofillCreditCardEnabled = false;
      FirefoxSuggest.SponsoredSuggestions = false;
    };

    profiles.${config.user} = {
      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
        "NixOS Wiki" = {
          urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "@nw" ];
        };
        "MyNixOS" = {
          urls = [{ template = "https://mynixos.com/search?q={searchTerms}"; }];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "@mn" ];
        };
        "SearXNG" = {
          urls = [{ template = "https://searxng.7mairot.com/search?q={searchTerms}"; }];
          iconUpdateURL = "https://raw.githubusercontent.com/searxng/searxng/master/src/brand/searxng-wordmark.svg";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "@searxng" "@sx" ];
        };
        "Google".metaData.alias = "@g";
      };
      search.force = true;
      search.default = "SearXNG";
      search.order = [ "SearXNG" "Google" ];
      
      # To display extentions: nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        canvasblocker
        cookie-autodelete
        darkreader
        ublock-origin
        user-agent-string-switcher
        privacy-badger
        sponsorblock
        return-youtube-dislikes
       ];
      settings = {
        "intl.locale.requested" = "fr,en_US";
        
        # Disable first-run stuff
        "browser.aboutConfig.showWarning" = false;
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.feeds.showFirstRunUI" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.uitour.enabled" = false;
        "startup.homepage_override_url" = "";
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.addedImportButton" = true;
        "extensions.pocket.enabled" = false;

        # Don't ask for download dir
        "browser.download.useDownloadDir" = false;
        
        # Disable translate prompt
        "browser.translations.automaticallyPopup" = false;
        "browser.translations.neverTranslateLanguages" = "en";
        
        # Disable Newtab page
        "browser.contentblocking.category" = "standard"; # "strict"
        "browser.newtabpage.pinned" = "";
        "browser.topsites.contile.enabled" = false;
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.topSitesRows" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.discoverystream.personalization.enabled" = false;
        "browser.newtabpage.activity-stream.discoverystream.saveToPocketCard.enabled" = false;
        "browser.newtabpage.activity-stream.discoverystream.sendToPocket.enabled" = false;
        "browser.newtabpage.activity-stream.discoverystream.spocTopsitesPlacement.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.aboutpreferences" = false;
        "browser.newtabpage.activity-stream.feeds.recommendationprovider" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.system.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # Disable Telemetry
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "beacon.enabled" = false;
        
        # Disable studdies
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
 
        # Disable crash reports
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        
        # Security settings
        "dom.security.https_only_mode" = true;
        "browser.region.network.url" = "";
        "browser.region.update.enabled" = false;
        "geo.provider.use_geoclue" = false;
        "privacy.trackingprotection.enabled" = true;
        "signon.autofillForms" = false;
        "network.auth.subresource-http-auth-allow" = 1;
        "media.peerconnection.enabled" = false;
        
        # Disable addons recommendation (uses Google Analytics)
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.discovery.enabled" = false;

        # UI customization
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            widget-overflow-fixed-list = [];
            unified-extensions-area = ["sponsorblocker_ajay_app-browser-action" "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action"];
            nav-bar = ["back-button" "forward-button" "stop-reload-button" "customizableui-special-spring1" "home-button" "urlbar-container" "fxa-toolbar-menu-button" "privatebrowsing-button" "downloads-button" "customizableui-special-spring2" "save-to-pocket-button" "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" "addon_darkreader_org-browser-action" "ublock0_raymondhill_net-browser-action" "jid1-mnnxcxisbpnsxq_jetpack-browser-action" "cookieautodelete_kennydo_com-browser-action" "unified-extensions-button"];
            toolbar-menubar = ["menubar-items"];
            TabsToolbar = ["tabbrowser-tabs" "new-tab-button" "alltabs-button"];
            PersonalToolbar = ["personal-bookmarks"];
          };
          seen = ["addon_darkreader_org-browser-action" "jid1-mnnxcxisbpnsxq_jetpack-browser-action" "ublock0_raymondhill_net-browser-action" "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action" "sponsorblocker_ajay_app-browser-action" "developer-button" "cookieautodelete_kennydo_com-browser-action"];
          dirtyAreaCache = ["unified-extensions-area" "nav-bar" "toolbar-menubar" "TabsToolbar" "PersonalToolbar"];
          currentVersion = 20;
          newElementCount = 6;
        };
      };
    };
  };
 
  xdg.mimeApps.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };
}