{}: final: prev:
with final.haskell.lib;
with final.lib; let
  haskellPackages = prev.haskellPackages.override (old: {
    overrides = final.lib.composeExtensions (old.overrides or (_: _: {})) (
      self: super: let
        xmonadrc = buildFromSdist (self.callPackage ../xmonadrc/default.nix {});
        xmobar-app = buildFromSdist (
          overrideCabal (self.callPackage ../xmobar-app/default.nix {})
          (old: {
            configureFlags =
              (old.configureFlags or [])
              ++ [
                "--ghc-options=-O2"
                "--ghc-options=-Wall"
                # Xmobar flags
                "-fwith_alsa"
                "-fwith_conduit"
                "-fwith_datezone"
                "-fwith_dbus"
                "-fwith_inotify"
                "-fwith_iwlib"
                "-fwith_mpd"
                "-fwith_mpris"
                "-fwith_rtsopts"
                "-fwith_threaded"
                "-fwith_utf8"
                "-fwith_uvmeter"
                "-fwith_weather"
                "-fwith_xft"
                "-fwith_xpm"
              ];
          })
        );
        addFontConfig = drv:
          drv.overrideAttrs (oa: {
            buildInputs =
              oa.buildInputs
              or []
              ++ [
                final.makeWrapper
              ];
            installPhase =
              oa.installPhase
              + ''
                wrapProgram $out/bin/${oa.meta.mainProgram} \
                  --prefix FONTCONFIG_FILE : ${final.makeFontsConf {fontDirectories = [final.nerd-fonts.jetbrains-mono];}}
              '';
          });
      in {
        xmonadrc = addFontConfig xmonadrc;
        xmobar-app = addFontConfig xmobar-app;
      }
    );
  });
in {
  inherit haskellPackages;
}
