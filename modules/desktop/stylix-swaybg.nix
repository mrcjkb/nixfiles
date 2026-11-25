{
  config,
  lib,
  pkgs,
  ...
}: let
  image = lib.escapeShellArg (toString config.stylix.image);
in {
  options.stylix.targets.swaybg.enable = config.lib.stylix.mkEnableWallpaper "Swaybg" true;

  config = lib.mkIf (config.stylix.enable && config.stylix.targets.swaybg.enable) {
    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "stylix-wallpaper";

        runtimeInputs = [pkgs.procps pkgs.swaybg];

        text = ''
          pkill -x swaybg || true
          exec swaybg -i ${image} -m ${config.stylix.imageScalingMode}
        '';
      })
    ];
  };
}
