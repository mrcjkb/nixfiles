import { Plugin } from "@opencode/plugin/tui";
import { disable, enable, isDisabled, toggle } from "./flag.js";

export default Plugin.define({
  id: "reviewers.tui",
  setup(context) {
    if (isDisabled()) context.ui.toast.show({ message: "Reviewers are off" });

    context.keymap.layer(() => ({
      mode: "global",
      commands: [
        {
          id: "reviewers.toggle",
          title: "Toggle reviewers",
          group: "Reviewers",
          bind: "ctrl+alt+r",
          palette: true,
          slash: { name: "reviewers", aliases: ["reviewer"], arguments: true },
          run: (input) => {
            const arg = String(input ?? "").trim().toLowerCase();
            if (arg === "on") enable();
            else if (arg === "off") disable();
            else toggle();
            const disabled = isDisabled();
            context.ui.toast.show({
              message: "Reviewers " + (disabled ? "off" : "on"),
              variant: "success",
            });
          },
        },
      ],
      bindings: ["reviewers.toggle"],
    }));
  },
});
