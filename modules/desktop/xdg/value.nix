{pkgs, ...}: let
  handler = "focus-browser.desktop";
  mimes = [
    "text/html"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
    "x-scheme-handler/mailto"
    "x-scheme-handler/chrome"
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/xhtml+xml"
    "application/x-extension-xhtml"
    "application/x-extension-xht"
  ];
  focusBrowser =
    pkgs.writers.writePython3 "focus-browser" {}
    (builtins.readFile ./focus-browser.py);
in {
  xdg.mime = {
    defaultApplications = pkgs.lib.genAttrs mimes (_: handler);
    addedAssociations =
      pkgs.lib.genAttrs mimes (_: "${handler};")
      // {
        "application/octet-stream" = "neovide.desktop;";
      };
  };
  environment.systemPackages = [
    (pkgs.makeDesktopItem {
      name = "focus-browser";
      desktopName = "Focus Browser";
      exec = "${focusBrowser} %U";
      mimeTypes = mimes;
    })
  ];
}
