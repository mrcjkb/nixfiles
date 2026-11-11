import fs from "fs";
import os from "os";
import path from "path";

const flagPath = path.join(
  process.env.XDG_STATE_HOME ?? path.join(os.homedir(), ".local", "state"),
  "opencode",
  ".reviewers-off",
);

export const isDisabled = () => fs.existsSync(flagPath);

const disable = () => {
  fs.mkdirSync(path.dirname(flagPath), { recursive: true });
  fs.writeFileSync(flagPath, "");
};

const enable = () => fs.rmSync(flagPath, { force: true });

export const toggle = () => {
  const wasDisabled = isDisabled();
  if (wasDisabled) enable();
  else disable();
  return !wasDisabled;
};
