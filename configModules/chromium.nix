{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = [ pkgs.google-chrome ];

  programs.chromium = {
    enable = true;
    extensions = [
      # uBlock Origin
      "cjpalhdlnbpafiamejdnhcphjbkeiagm"
      # Bitwarden
      "nngceckbapebfimnlniiiahkandclblb"
      # Dark Reader
      "eimadpbcbfnmbkopoojfekhnkhdbieeh"
      # Privacy Badger
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"
      # Claude (Anthropic)
      "fcoeoabgfenejglbffodgkkbkcdhcgfn"
    ];
    extraOpts = {
      # Disable telemetry
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "AutofillCreditCardEnabled" = false;
      "AutofillAddressEnabled" = false;
      "BuiltInDnsClientEnabled" = false;
      "MetricsReportingEnabled" = false;
      "SearchSuggestEnabled" = false;
      "AlternateErrorPagesEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [ "fr" "en-US" ];
      
      # Search
      "DefaultSearchProviderEnabled" = true;
      "DefaultSearchProviderName" = "SearXNG";
      "DefaultSearchProviderSearchURL" = "https://${config.searxngURL}/search?q={searchTerms}";
      
      # Remove annoying things
      "BookmarkBarEnabled" = true;
      "HomepageLocation" = "about:blank";
      "NewTabPageLocation" = "about:blank";
      "RestoreOnStartup" = 1;
      "ShowHomeButton" = true;
      
      # Sécurity settings
      "BlockThirdPartyCookies" = true;
      "CookiesSessionOnlyForUrls" = [ "[*.]example.com" ];
      "DefaultNotificationsSetting" = 2; # Block
      "EnableDoNotTrack" = true;
    };
  };
}
