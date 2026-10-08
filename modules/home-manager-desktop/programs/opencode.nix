{
  pkgs,
  lib,
  ...
}: let
  mrcjkb-dev = pkgs.fetchFromGitHub {
    owner = "mrcjkb";
    repo = "mrcjkb.github.io";
    hash = "sha256-u8oSYcB5n3d1umnpfpKEB+tBomlgK4Wf76ChjT+/qBg=";
    rev = "ad5ca6dcb63a2ebd11f3a99d5ff917ac4e49f5fc";
  };
  qualified-import-post = "${mrcjkb-dev}/posts/2026-10-06-design-for-qualified-import.markdown";
in {
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      lsp = true;
      permission = {
        bash = {
          "*" = "ask";

          # Basic utilities
          "awk *" = "allow";
          "basename *" = "allow";
          "bat *" = "allow";
          "cat *" = "allow";
          "comm *" = "allow";
          "df *" = "allow";
          "diff *" = "allow";
          "dirname *" = "allow";
          "du *" = "allow";
          "echo *" = "allow";
          "eza *" = "allow";
          "fd *" = "allow";
          "file *" = "allow";
          "find *" = "allow";
          "grep *" = "allow";
          "head *" = "allow";
          "jq *" = "allow";
          "ls *" = "allow";
          "nproc" = "allow";
          "pwd" = "allow";
          "realpath *" = "allow";
          "rg *" = "allow";
          "sed *" = "allow";
          "sort *" = "allow";
          "stat *" = "allow";
          "tail *" = "allow";
          "timeout *" = "allow";
          "treefmt *" = "allow";
          "uname *" = "allow";
          "uniq *" = "allow";
          "wc *" = "allow";
          "whereis *" = "allow";
          "which *" = "allow";
          "whoami" = "allow";

          # Version control
          "jj log *" = "allow";
          "jj show *" = "allow";
          "jj diff *" = "allow";
          "git diff *" = "allow";
          "git log *" = "allow";
          "git show *" = "allow";
          "git status *" = "allow";

          # Nix
          "nix *" = "allow";
          "nix run *" = "ask";
          "nix store *" = "ask";

          # Haskell
          "cabal *" = "allow";
          "ghc --version *" = "allow";
          "ghc-pkg describe *" = "allow";
          "ghc-pkg list *" = "allow";
          "ghci --version *" = "allow";
          "runghc --version *" = "allow";

          # Rust
          "cargo *" = "allow";

          # Pre-commit
          "pre-commit run *" = "allow";
        };
        external_directory = {
          "/nix/store/*" = "allow";
        };
        edit = "deny";
        write = "deny";
      };
      plugin = [
        "@dietrichgebert/ponytail"
        "caveman-opencode-plugin"
      ];
    };
    context = lib.concatStringsSep "\n\n" [
      ''
        RULE: NEVER write code comments.
        Code should be self-explanatory, but not overly verbose.
        Doc comments (e.g. haddock, rustdoc) are okay for public API, but should be kept concise, using the [diataxis REFERENCE format](https://diataxis.fr/reference/).
      ''
      ''
        RULE: You must NEVER use the 'edit' or 'write' tools to modify code.
        These tools are permanently denied.
        All code modifications MUST go through the Serena MCP tools (serena_replace_symbol_body, serena_insert_after_symbol, serena_insert_before_symbol, serena_replace_content, serena_rename_symbol, serena_safe_delete_symbol).
        When you need to modify code:
        1. First read and understand the code semantically using serena_get_symbols_overview, serena_find_symbol, serena_read_memory.
        2. Then apply changes using the appropriate Serena symbol-level tool (replace_symbol_body, insert_after_symbol, etc.).
        3. For bulk or regex-based replacements across a file, use serena_replace_content.
        4. Never fall back to raw text editing. If a Serena tool cannot express the change cleanly, make a suggestion, but do not edit.
      ''
      "RULE: Before writing ANY code, ALWAYS activate the `ponytail` skill."
      "RULE: Search for dependencies ONLY in the nix store if the project is built with nix."
      "RULE: Apply the Single Responsibility Principle:
        A function should do one thing, and a unit (function, class, module) should
        have exactly one reason to change. Two or more concerns in one unit is a
        violation.
      "
      "RULE: Always design Haskell for QUALIFIED IMPORT. See: ${qualified-import-post}."
      (builtins.readFile ./HASKELL_RULES.md)
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
    agents = {
      rules-reviewer = ''
        ---
        description: Reviews a code change against the context rules.
        mode: subagent
        temperature: 0.1
        permission:
          task: deny
        ---

        Review uncommitted changes against every RULE in the system context:
        NO_CODE_COMMENTS, HASKELL_RULES (if applicable).

        One line per violation: `<rule>: <file>:L<line>: <violation>. <fix>.`
        If none, reply `Rules OK.` Do not edit files.
      '';

      ponytail-reviewer = ''
        ---
        description: Reviews a code change for over-engineering.
        mode: subagent
        temperature: 0.1
        permission:
          task: deny
        ---

        Activate the `ponytail-review` skill and follow its format exactly.

        Review the current uncommitted change (`jj diff` or `git diff`).
        Over-engineering and complexity only. Make no edits.
      '';

      srp-reviewer = ''
        ---
        description: Reviews a code change for Single Responsibility Principle violations.
        mode: subagent
        temperature: 0.1
        permission:
          task: deny
        ---

        Review uncommitted changes for Single Responsibility Principle violations only.

        A function should do one thing, and a unit (function, class, module) should
        have exactly one reason to change. Two or more concerns in one unit is a
        violation.

        Example:

        Bad: (three concerns in one function):
            load_config(raw):
                data = parse(raw)                 # parse
                if data.version == 1:
                    data = migrate_from_v1(data)  # migrate
                return deserialize(data)          # deserialize

        Good: (one concern per unit, composed at the top):
            parse(raw)        -> raw_data
            migrate(raw_data) -> current_data
            deserialize(data) -> config
            load_config(raw)  -> deserialize(migrate(parse(raw)))   # orchestration only

        For each changed unit with multiple concerns, report one line:

        `<file>:L<line>: <the distinct concerns>. <smallest split that separates them>.`

        If every changed unit has a single concern, reply `SRP OK.`
        Ignore style, complexity, correctness, and naming. Do not edit files.
      '';
    };
  };
  xdg.configFile."opencode/plugins/reviewers.js".source = ./opencode-reviewers.js;
}
