{inputs, ...}: {
  nixos.modules.framework = {
    imports = [
      inputs.nixos-hardware.nixosModules.framework-16-amd-ai-300-series
    ];
  };
}
