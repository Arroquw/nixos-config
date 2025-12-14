{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package =
      pkgs.firefox; # inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin;
    # package = pkgs.wrapFirefox pkgs.firefox-wayland {
    #   extraExtensions = [
    #     (fetchfirefoxaddon {
    #       name = "FastForward";
    #       url =
    #         "https://addons.mozilla.org/firefox/downloads/file/4177101/fastforwardteam-0.2334.xpi";
    #       sha256 = "1l2yp7zhrlsblxk5dd47z8vlln1bpwdd1h21dcqhi7s64ab2346p";
    #     })
    #     (fetchfirefoxaddon {
    #       name = "Catppuccin";
    #       url =
    #         "https://addons.mozilla.org/firefox/downloads/file/4177101/fastforwardteam-0.2334.xpi";
    #       sha256 = "1h768ljlh3pi23l27qp961v1hd0nbj2vasgy11bmcrlqp40zgvnr";
    #     })
    #   ];

    #   extraPolicies = {
    #     CaptivePortal = false;
    #     DisableFirefoxStudies = true;
    #     DisablePocket = true;
    #     DisableTelemetry = true;
    #     DisableFirefoxAccounts = false;
    #     NoDefaultBookmarks = true;
    #     OfferToSaveLogins = false;
    #     OfferToSaveLoginsDefault = false;
    #     PasswordManagerEnabled = false;
    #     FirefoxHome = {
    #       Search = true;
    #       Pocket = false;
    #       Snippets = false;
    #       TopSites = false;
    #       Highlights = false;
    #     };
    #     UserMessaging = {
    #       ExtensionRecommendations = false;
    #       SkipOnboarding = true;
    #     };
    #   };
    # };
    profiles.default = { isDefault = true; };
  };
}
