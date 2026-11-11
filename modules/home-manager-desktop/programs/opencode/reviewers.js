const MUTATORS = new Set([
  "edit",
  "write",
  "patch",
  "multiedit",
  "serena_replace_symbol_body",
  "serena_insert_after_symbol",
  "serena_insert_before_symbol",
  "serena_replace_content",
  "serena_replace_in_files",
  "serena_rename_symbol",
  "serena_safe_delete_symbol",
]);

const REVIEWERS = [
  ["rules-reviewer", "rules review"],
  ["ponytail-reviewer", "over-engineering review"],
  ["srp-reviewer", "SRP review"],
];

const PROMPT = "Review the current uncommitted changes. Run 'jj diff' or 'git diff'.";
const EDIT_HINTS =
  /\bs\.edit\s*\.|replace_content|replace_symbol_body|insert_after_symbol|insert_before_symbol|replace_in_files|rename_symbol|safe_delete_symbol/;
const isMutator = (tool, input) => {
  if (MUTATORS.has(tool)) return true;
  if ([...MUTATORS].some((name) => tool.endsWith("_" + name))) return true;
  if (tool.endsWith("serena_repl")) {
    const code = typeof input?.code === "string" ? input.code : "";
    return EDIT_HINTS.test(code);
  }
  return false;
};

const reviewers = REVIEWERS.map(
  ([agent, description]) => "- agent `" + agent + "`, description `" + description + "`",
).join("\n");

const KICKOFF = [
  "The change is ready for review.",
  "Call the `subagent` tool " + REVIEWERS.length + " times in ONE message (foreground):",
  reviewers,
  "Prompt each with: " + PROMPT,
].join("\n");

export default {
  id: "reviewers",
  async setup(ctx) {
    const dirty = new Set();
    const controller = new AbortController();

    await ctx.tool.hook("execute.after", (event) => {
      if (isMutator(event.tool, event.input)) dirty.add(event.sessionID);
    });

    const review = async (sessionID) => {
      if (!dirty.delete(sessionID)) return;
      const session = await ctx.session.get({ sessionID });
      if (session.parentID) return;
      if (session.location?.directory !== ctx.location?.directory) return;
      await ctx.session
        .synthetic({ sessionID, text: KICKOFF, description: "review request" })
        .catch((error) => console.error("[reviewers] " + String(error)));
    };

    void (async () => {
      try {
        for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
          const type = event.type;
          if (type !== "session.idle" && type !== "session.execution.succeeded") continue;
          const sessionID = event.data?.sessionID ?? event.sessionID;
          if (sessionID) await review(sessionID);
        }
      } catch (error) {
        if (!controller.signal.aborted) console.error("[reviewers] " + String(error));
      }
    })();

    return () => controller.abort();
  },
};

