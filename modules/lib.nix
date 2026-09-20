{lib, ...}: {
  _module.args.findModulesList = import ../lib/find-modules-list.nix {inherit lib;};
}
