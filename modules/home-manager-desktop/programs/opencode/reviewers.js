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
const isMutator = (tool) => MUTATORS.has(tool) || [...MUTATORS].some((name) => tool.endsWith("_" + name));

function lastAssistantText(messages) {
  for (let i = messages.length - 1; i >= 0; i--) {
    const message = messages[i];
    if (message.type !== "assistant") continue;
    const text = (message.content ?? [])
      .filter((part) => part.type === "text")
      .map((part) => part.text)
      .join("\n")
      .trim();
    if (text) return text;
  }
  return "";
}

export default {
  id: "reviewers",
  async setup(ctx) {
    const dirty = new Set();
    const reviewing = new Set();
    const controller = new AbortController();

    await ctx.tool.hook("execute.after", (event) => {
      if (isMutator(event.tool)) dirty.add(event.sessionID);
    });

    const review = async (sessionID) => {
      const session = await ctx.session.get({ sessionID });
      if (session.parentID) return;
      if (reviewing.has(sessionID)) {
        reviewing.delete(sessionID);
        dirty.delete(sessionID);
        return;
      }
      if (!dirty.delete(sessionID)) return;
      reviewing.add(sessionID);
      try {
        const reports = [];
        for (const [agent, description] of REVIEWERS) {
          const child = await ctx.session.create({ title: description, parentID: sessionID });
          await ctx.session.switchAgent({ sessionID: child.id, agent });
          await ctx.session.prompt({ sessionID: child.id, text: PROMPT });
          await ctx.session.wait({ sessionID: child.id });
          const text = lastAssistantText(await ctx.session.context({ sessionID: child.id }));
          if (text) reports.push("## " + agent + "\n" + text);
        }
        if (reports.length > 0) {
          await ctx.session.prompt({ sessionID, text: reports.join("\n\n") });
        } else {
          reviewing.delete(sessionID);
        }
      } catch (error) {
        reviewing.delete(sessionID);
        console.error("[reviewers] " + String(error));
      }
    };

    void (async () => {
      try {
        for await (const event of ctx.event.subscribe({ types: ["session.idle"], signal: controller.signal })) {
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

