# Interactive tree file manager
{
  enable = false;
  enableZshIntegration = true;
  settings = {
    modal = true;
    verbs = [
      {
        invocation = "blop {name}\\.{type}";
        execution = "mkdir {parent}/{type} && nvim {parent}/{type}/{name}.{type}";
        from_shell = true;
      }
    ];
  };
}
