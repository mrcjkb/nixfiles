# nixfiles
A nix flake for building a NixOS system configuration with defaults I probably want on all my systems.
Returns a wrapper around `pkgs.lib.nixosSystem` (see also the [NixOS wiki](https://nixos.wiki/wiki/Flakes))

## Usage
```nix
# flake.nix
{
  description = "NixOS configuration";

  inputs.base = {
    url = github:MrcJkb/nixfiles;
  };

  outputs = { self, base, ... }@attrs: {
    nixosConfigurations.<hostName> = base.nixosSystem {
        userEmail = "foo@bar"; # for git, etc.
        extraModules = [
          # Optional
          ./configuration.nix
        ];
      };
    };
}

```
`<hostName>` is the host name of the configuration.

