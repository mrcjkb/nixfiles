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

const PROMPT = "Review the current uncommitted changes. Run `jj diff` or `git diff`.";

export const Reviewers = async ({ client }) => {
  const dirty = new Set();
  const children = new Set();
  const reviewing = new Set();
  const log = (level, message) =>
    client.app.log({ body: { service: "reviewers", level, message } }).catch(() => ({}));

  return {
    "tool.execute.after": async (input) => {
      if (MUTATORS.has(input.tool)) dirty.add(input.sessionID);
    },
    event: async ({ event }) => {
      if (event.type === "session.created") {
        if (event.properties.info.parentID) children.add(event.properties.info.id);
        return;
      }
      if (event.type !== "session.idle") return;
      const id = event.properties.sessionID;
      if (children.has(id)) return;
      if (reviewing.has(id)) {
        reviewing.delete(id);
        dirty.delete(id);
        return;
      }
      if (!dirty.delete(id)) return;
      try {
        const parts = REVIEWERS.map(([agent, description]) => ({
          type: "subtask",
          agent,
          description,
          prompt: PROMPT,
        }));
        await client.session.promptAsync({ path: { id }, body: { parts } });
        reviewing.add(id);
      } catch (e) {
        await log("error", String(e));
      }
    },
  };
};

