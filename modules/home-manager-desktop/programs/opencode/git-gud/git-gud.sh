is_shell() {
  [ -n "${OPENCODE:-}" ] && return 0

  local parent_cmd=""
  if [ -f "/proc/$PPID/comm" ]; then
    read -r parent_cmd < "/proc/$PPID/comm" || true
  elif command -v ps >/dev/null 2>&1; then
    read -r parent_cmd <<< "$(ps -o comm= -p "$PPID" 2>/dev/null || true)"
  fi

  case "${parent_cmd##*/}" in
    *opencode*|zsh|bash|sh|fish|dash|ash|ksh|nu) return 0 ;;
    *) return 1 ;;
  esac
}

if ! is_shell; then
  exec git "$@"
fi

if jj root >/dev/null 2>&1; then
  subcmd=""
  skip_next=0
  for arg in "$@"; do
    if [ "$skip_next" -eq 1 ]; then
      skip_next=0
      continue
    fi
    case "$arg" in
      -C|-c|--exec-path|--git-dir|--work-tree)
        skip_next=1
        ;;
      --version|-v|--help|-h)
        exec git "$@"
        ;;
      -*)
        ;;
      *)
        subcmd="$arg"
        break
        ;;
    esac
  done

  case "$subcmd" in
    status|st)
      echo "error: This repository is managed by Jujutsu (jj)." >&2
      echo "hint: Use 'jj status' (or 'jj st') instead of 'git $subcmd'." >&2
      exit 1
      ;;
    add)
      echo "error: This repository is managed by Jujutsu (jj)." >&2
      echo "hint: In Jujutsu, there is no index or staging area." >&2
      echo "hint: Working copy changes are automatically part of the current revision (@)." >&2
      echo "hint: Use 'jj diff' or 'jj status' to inspect changes, and 'jj describe' to name them." >&2
      exit 1
      ;;
    commit|ci)
      echo "error: This repository is managed by Jujutsu (jj)." >&2
      echo "hint: In Jujutsu, describe the current revision using:" >&2
      echo "hint:   jj describe -m \"...\"" >&2
      echo "hint: Or create a new revision from specific paths using:" >&2
      echo "hint:   jj commit [paths] -m \"...\"" >&2
      exit 1
      ;;
    diff)
      echo "error: This repository is managed by Jujutsu (jj)." >&2
      echo "hint: Use 'jj diff' instead of 'git diff'." >&2
      exit 1
      ;;
    log)
      echo "error: This repository is managed by Jujutsu (jj)." >&2
      echo "hint: Use 'jj log' instead of 'git log'." >&2
      exit 1
      ;;
    show)
      echo "error: This repository is managed by Jujutsu (jj)." >&2
      echo "hint: Use 'jj show' instead of 'git show'." >&2
      exit 1
      ;;
    branch|checkout|switch)
      echo "error: This repository is managed by Jujutsu (jj)." >&2
      echo "hint: Jujutsu uses bookmarks and anonymous revisions instead of git branches." >&2
      echo "hint:   jj bookmark list" >&2
      echo "hint:   jj bookmark create <name>" >&2
      echo "hint:   jj new <target>" >&2
      exit 1
      ;;
    rebase)
      echo "error: This repository is managed by Jujutsu (jj)." >&2
      echo "hint: Use 'jj rebase' instead of 'git rebase'." >&2
      exit 1
      ;;
    restore|reset)
      echo "error: This repository is managed by Jujutsu (jj)." >&2
      echo "hint: Use 'jj restore' or 'jj edit' instead of 'git $subcmd'." >&2
      exit 1
      ;;
    push)
      echo "error: This repository is managed by Jujutsu (jj)." >&2
      echo "hint: In Jujutsu, push bookmarks using:" >&2
      echo "hint:   jj git push" >&2
      echo "hint:   jj git push -b <bookmark>" >&2
      exit 1
      ;;
    pull|fetch)
      echo "error: This repository is managed by Jujutsu (jj)." >&2
      echo "hint: Use 'jj git fetch' instead of 'git $subcmd'." >&2
      exit 1
      ;;
    *)
      # Unintercepted commands pass through
      ;;
  esac
fi

# Pass through to real git
exec git "$@"
