{inputs, ...}: {
  nixos.modules.river-rhine = {
    config,
    pkgs,
    defaultUser,
    ...
  }: let
    regisseurConfig = pkgs.runCommand "regisseur-config.dhall" {} ''
      defaults=$(${config.programs.regisseur.package}/bin/regisseur --print-default-config)
      cat > $out <<EOF
      let defaults = $defaults in
      defaults //
        { theme =
            defaults.theme
              // { font = Some "JetBrains Mono Nerd Font Mono" }
        , browser = Some "firefox"
        , searchEngines =
            [ { name = "hoogle.ners"
              , url = "https://hoogle.ners.ch/?hoogle="
              }
            , { name = "hoogle.ida"
              , url = "https://hoogle.digital-autonomy.institute/?hoogle="
              }
            ]
        , customModes =
            [ { name = "power"
              , entries =
                  [ { label = "Shutdown", command = "systemctl poweroff" }
                  , { label = "Reboot", command = "systemctl reboot" }
                  , { label = "Hibernate", command = "systemctl hibernate" }
                  ]
              }
            ]
        }
      EOF
    '';
  in {
    imports = [inputs.river-rhine.nixosModules.default];

    programs = {
      river-rhine = {
        enable = true;
        haskellPackages = pkgs.river-rhine-haskellPackages;
        package = pkgs.river-rhine-config;
        session.extraCommands = ''
          export GTK_CSD=0
          export XKB_DEFAULT_OPTIONS=caps:escape
        '';
        session.extraPackages = with pkgs; [grim slurp satty wtype wlr-randr wdisplays];
      };
      rhinebar = {
        enable = true;
        haskellPackages = pkgs.river-rhine-haskellPackages;
        package = pkgs.rhinebar-config;
      };
      regisseur = {
        enable = true;
        haskellPackages = pkgs.river-rhine-haskellPackages;
        config = regisseurConfig;
      };
    };

    services = {
      concierge = {
        enable = true;
        haskellPackages = pkgs.river-rhine-haskellPackages;
        users = [defaultUser];
      };
      displayManager.defaultSession = "river-rhine";
    };
  };
}
