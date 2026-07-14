pkgs: {
  enable = true;
  enableMcpIntegration = true;
  settings = {
    permission = {
      ask = "allow";
      bash = "ask";
      edit = "deny";
      write = "deny";
    };
    plugin = [
      "@dietrichgebert/ponytail"
    ];
    instructions = [
      ''
        RULE: You must NEVER use the 'edit' or 'write' tools to modify code.
        These tools are permanently denied.
        All code modifications MUST go through the Serena MCP tools (serena_replace_symbol_body, serena_insert_after_symbol, serena_insert_before_symbol, serena_replace_content, serena_rename_symbol, serena_safe_delete_symbol).
        When you need to modify code:
          1. First read and understand the code semantically using serena_get_symbols_overview, serena_find_symbol, serena_read_memory.
          2. Then apply changes using the appropriate Serena symbol-level tool (replace_symbol_body, insert_after_symbol, etc.).
          3. For bulk or regex-based replacements across a file, use serena_replace_content.
          4. Never fall back to raw text editing. If a Serena tool cannot express the change cleanly, make a suggestion, but do not edit. Before writing ANY code, ALWAYS activate the `ponytail` skill.
      ''
      "RULE: Search for dependencies ONLY in the nix store."
    ];
    skills = let
      agent-skills = pkgs.fetchFromGitHub {
        owner = "joshuadavidthomas";
        repo = "agent-skills";
        hash = "sha256-SbkWvA6UXH9QyJdqKtYl6PG9CPCuW+6nBVK+SvR0CKI=";
        rev = "d5d37601adb0b23bf49167d292a74ddf8d4a2575";
      };
    in {
      diataxis = "${agent-skills}/diataxis/SKILL.md";
    };
  };
}
