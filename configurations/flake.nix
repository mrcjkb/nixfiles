{
  description = "NixOS configuration";

  inputs.base = {
    url = github:MrcJkb/nixfiles;
  };

  outputs = {
    self,
    base,
    ...
  } @ attrs: {
  };
}
