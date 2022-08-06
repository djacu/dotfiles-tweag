{pkgs}: {
  enable = true;
  package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    forceWayland = true;
    extraPolicies.ExtensionSettings = {};
  };
  profiles.default = {
    id = 0;
    name = "Default";
    isDefault = true;
    settings = {
      "browser.download.useDownloadDir" = false; # Ask for download location
      "browser.in-content.dark-mode" = true; # Dark mode
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false; # Disable top stories
      "browser.newtabpage.activity-stream.feeds.sections" = false;
      "browser.newtabpage.activity-stream.feeds.system.topstories" = false; # Disable top stories
      "browser.newtabpage.activity-stream.section.highlights.includePocket" = false; # Disable pocket
      "extensions.pocket.enabled" = false; # Disable pocket
      "signon.autofillForms" = false; # Disable built-in form-filling
      "signon.rememberSignons" = false; # Disable built-in password manager
      "ui.systemUsesDarkTheme" = true; # Dark mode
    };
  };
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    lastpass-password-manager
    privacy-badger
    sponsorblock
    translate-web-pages
    tree-style-tab
    ublock-origin
  ];
}
