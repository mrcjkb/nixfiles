{...}: {
  homeManager.configurations."mrcjk@x86_64-linux" = {
    system = "x86_64-linux";
    user = "mrcjk";
    userEmail = "marc@jakobi.dev";
    modules = [
      "base"
      "desktop"
      "shell-aliases"
    ];
    extraModules = [
      {
        home = {
          username = "mrcjk";
          homeDirectory = "/home/mrcjk";
          stateVersion = "26.05";
        };
        programs.home-manager.enable = true;
      }
    ];
  };
}
