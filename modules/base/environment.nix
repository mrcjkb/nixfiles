{
  pkgs,
  lib,
  ...
}: {
  environment = {
    sessionVariables = {
      XDG_CACHE_HOME = lib.mkDefault "\${HOME}/.cache";
      XDG_CONFIG_HOME = lib.mkDefault "\${HOME}/.config";
      XDG_BIN_HOME = lib.mkDefault "\${HOME}/.local/bin";
      XDG_DATA_HOME = lib.mkDefault "\${HOME}/.local/share";
      XDG_RUNTIME_DIR = lib.mkDefault "/run/user/1000";
      EDITOR = lib.mkDefault "nvim";
      BROWSER = lib.mkDefault "zen";
      TZ = lib.mkDefault "Europe/Berlin";
      # BAT_THEME = lib.mkDefault "Material-darker";

      PAGER = lib.mkDefault "page -q 90000 -z 90000";
      MANPAGER = lib.mkDefault "page -t man";
      NIX_AUTO_RUN = lib.mkDefault "1";
      NIX_PATH = lib.mkDefault "nixpkgs=flake:nixpkgs";
    };

    shells = with pkgs; [
      zsh
      nushell
    ];

    shellInit = ''
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
    '';

    pathsToLink = [
      "/share/nix-direnv"
    ];

    # Rip out default packages like nano, perl and rsync
    defaultPackages = lib.mkForce [];
  };
}
