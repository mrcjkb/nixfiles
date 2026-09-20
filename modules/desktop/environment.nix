{config, ...}: {
  environment.sessionVariables = {
    # Workaround for cursor theme not being recognized
    XCURSOR_PATH = [
      "${config.system.path}/share/icons"
      "$HOME/.icons"
      "$HOME/.nix-profile/share/icons/"
    ];
    GTK_DATA_PREFIX = [
      "${config.system.path}"
    ];
  };
}
