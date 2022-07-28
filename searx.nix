{ package }:
{
  services.searx = { # Meta search-engine
    enable = true;
    inherit package;
    settings = {
      use_default_settings = true;
      general = {
        instance_name = "Marc's searx";
        debug = false;
      };
      search = {
        safe_search = 1; # 0 = None, 1 = Moderate, 2 = Strict
          autocomplete = "google"; # Existing autocomplete backends: "dbpedia", "duckduckgo", "google", "startpage", "swisscows", "qwant", "wikipedia" - leave blank to turn it off by default
          default_lang = "en";
      };
      server = {
        secret_key = "U-ON-SJ[crJCwUb!#&bQ)00aI3|7\'L9hpQUoLtk$vr9\"xME|NS7Ptm@J\>sj=0W";
      };
      ui = {
        default_theme = "oscar";
        default_locale = "en";
      };
      outgoing = {
        request_timeout = 10.0;
        useragent_suffix = "sx";
      };
      engines = [
      {
        name = "archwiki";
        engine = "archlinux";
        shortcut = "aw";
      }
      {
        name = "wikipedia";
        engine = "wikipedia";
        shortcut = "w";
        base_url = "https://wikipedia.org/";
      }
      {
        name = "duckduckgo";
        engine = "duckduckgo";
        shortcut = "ddg";
      }
      {
        name = "github";
        engine = "github";
        shortcut = "gh";
      }
      {
        name = "google";
        engine = "google";
        shortcut = "g";
        use_mobile_ui = false;
      }
      {
        name = "hoogle";
        engine = "xpath";
        search_url = "https://hoogle.haskell.org/?hoogle={query}&start={pageno}";
        results_xpath = "//div[@class=\"result\"]";
        title_xpath = "./div[@class=\"ans\"]";
        url_xpath = "./div[@class=\"ans\"]//a/@href";
        content_xpath = "./div[contains(@class, \"doc\")]";
        categories = "it";
        shortcut = "h";
      }
      ];
    };
  };
}
