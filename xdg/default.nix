let
  browser = "brave";
in {
  mime = {
    defaultApplications = {
      "text/html" = "${browser}.desktop";
      "x-scheme-handler/http" = "${browser}.desktop";
      "x-scheme-handler/https" = "${browser}.desktop";
      "x-scheme-handler/about" = "${browser}.desktop";
      "x-scheme-handler/unknown" = "${browser}.desktop";
      "x-scheme-handler/mailto" = "${browser}.desktop";
      "x-scheme-handler/chrome" = "${browser}.desktop";
      "application/x-extension-htm" = "${browser}.desktop";
      "application/x-extension-html" = "${browser}.desktop";
      "application/x-extension-shtml" = "${browser}.desktop";
      "application/xhtml+xml" = "${browser}.desktop";
      "application/x-extension-xhtml" = "${browser}.desktop";
      "application/x-extension-xht" = "${browser}.desktop";
    };
    addedAssociations = {
      "x-scheme-handler/http" = "${browser}.desktop;";
      "x-scheme-handler/https" = "${browser}.desktop;";
      "x-scheme-handler/chrome" = "${browser}.desktop;";
      "text/html" = "${browser}.desktop;";
      "application/x-extension-htm" = "${browser}.desktop;";
      "application/x-extension-html" = "${browser}.desktop;";
      "application/x-extension-shtml" = "${browser}.desktop;";
      "application/xhtml+xml" = "${browser}.desktop;";
      "application/x-extension-xhtml" = "${browser}.desktop;";
      "application/x-extension-xht" = "${browser}.desktop;";
      "application/octet-stream" = "neovide.desktop;";
    };
  };
}
