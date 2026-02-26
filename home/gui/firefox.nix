{ ... }:

let
  profileName = "default";
in
{
  stylix.targets.firefox = {
    enable = true;
    profileNames = [ profileName ];
    colorTheme.enable = true;
  };

  programs.firefox = {
    enable = true;
    languagePacks = [
      "en-US"
      "pt-BR"
    ];

    policies = {
      Cookies = {
        # Allow these sites to save cookies normally
        Allow = [
          "https://github.com"
          "https://mail.google.com"
          "https://gemini.google.com"
          "https://accounts.google.com"
          "https://www.youtube.com"
          "https://classroom.google.com"
          "https://www.twitch.tv"
          "https://www.reddit.com"
          "https://web.whatsapp.com"
          "https://account.proton.me"
        ];
        Locked = true;
        Behavior = "reject-tracker-and-partition-foreign";
      };
      SanitizeOnShutdown = {
        Cache = true;
        Cookies = false;
        FormData = true;
        History = true;
        Sessions = true;
        SiteSettings = false;
        Locked = true;
      };
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        SuspectedFingerprinting = true;
        Category = "strict";
        BaselineExceptions = true;
        ConvenienceExceptions = false;
      };
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableFormHistory = true;
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;

      };
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "always";
      GenerativeAI = {
        Enabled = false;
        Locked = true;
      };
      TranslateEnabled = false;
      PasswordManagerEnabled = false;
      DisableProfileRefresh = true;
      DisableMasterPasswordCreation = true;
      DisableSetDesktopBackground = true;
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        Stories = false;
        SponsoredPocket = false;
        SponsoredStories = false;
        Snippets = false;
        Locked = true;
      };
      ExtensionUpdate = true;
      DisableSystemAddonUpdate = true;
      DisableSecurityBypass = {
        SafeBrowsing = true;
        InvalidCertificate = true;
      };
      DisableProfileImport = true;
      DisableDefaultBrowserAgent = true;
      DisableAppUpdate = true;
      BackgroundAppUpdate = false;
      AutofillCreditCardEnabled = false;
      AutofillAddressEnabled = false;
      AppAutoUpdate = false;
      OfferToSaveLogins = false;
      SearchSuggestEnabled = false;
      SkipTermsOfUse = true;
      BrowserDataBackup = {
        AllowBackup = false;
        AllowRestore = false;
      };
      HttpsOnlyMode = "force_enabled";
      DNSOverHTTPS = {
        Enabled = true;
        Locked = true;
        Fallback = true;
      };

      ExtensionSettings = {
        "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Bitwarden:
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        # Firefox Color:
        "FirefoxColor@mozilla.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-color/latest.xpi";
          installation_mode = "force_installed";
        };
        # Sponsor Block:
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
        # Dark Reader:
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        # Brazilian Portuguese Dictionary
        "pt-BR@dellalibera.sf.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/verificador-ortográfico-para-p/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    profiles = {
      "${profileName}" = {
        id = 0;
        name = profileName;
        isDefault = true;

        search = {
          force = true;
          privateDefault = "ddg";
          default = "ddg";
        };

        settings = {
          # General UI
          "media.hardwaremediakeys.enabled" = false;
          "mousewheel.default.delta_multiplier_y" = 275;
          "general.autoScroll" = true;
          "middlemouse.paste" = false;

          # Theming
          "layout.css.prefers-color-scheme.content-override" = 0;
          "ui.systemUsesDarkTheme" = 1;

          # Privacy (Not covered by Policy)
          "privacy.donottrackheader.enabled" = true;
          "privacy.partition.network_state.ocsp_cache" = true;
          "geo.enabled" = false;

          # Networking
          "network.dns.disablePrefetch" = true;
          "network.prefetch-next" = false;
          "network.predictor.enabled" = false;
          "network.captive-portal-service.enabled" = false;
          "network.connectivity-service.enabled" = false;

          # UI
          "browser.uitour.enabled" = false;
          "browser.urlbar.suggest.engines" = false;

          "webgl.disabled" = false;
        };

        # Whether to override all previous firefox settings.
        extensions.force = true;

      };
    };
  };
}
