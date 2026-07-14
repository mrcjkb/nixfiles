pkgs: {
  enable = true;
  servers = {
    serena = {
      enabled = true;
      command = "serena";
      args = [
        "start-mcp-server"
        "--context"
        "ide"
        "--project"
        "."
      ];
    };
    context7 = {
      enabled = false;
      url = "https://mcp.context7.com/mcp";
      headers.CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
    };
  };
}
