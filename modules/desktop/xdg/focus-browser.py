import json
import os
import socket
import subprocess
import sys
import time

urls = sys.argv[1:]
subprocess.Popen(["zen", *urls], start_new_session=True)

app_ids = ["zen", "firefox", "chromium", "chrome", "brave", "vivaldi"]
runtime = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
statusPath = os.path.join(runtime, "river-rhine", "status.json")
controlPath = os.path.join(runtime, "river-rhine", "control.sock")

deadline = time.monotonic() + 4
state = None
found = None
while time.monotonic() < deadline and found is None:
    try:
        with open(statusPath) as handle:
            state = json.load(handle)
    except (OSError, ValueError):
        state = None
    if state:
        for identifier, app_id in state.get("apps", {}).items():
            if any(pattern in app_id.lower() for pattern in app_ids):
                tag = next(
                    (
                        tag
                        for tag, windows in state.get("contents", {}).items()
                        if int(identifier) in windows
                    ),
                    None,
                )
                if tag is not None:
                    found = (identifier, tag)
                    break
    if found is None:
        time.sleep(0.1)

if found is None or state is None:
    sys.exit(0)

identifier, tag = found
outputs = state.get("outputs", {})


def box(value):
    return (value.get("y", 0), value.get("x", 0))


chosen = next(
    (key for key, value in outputs.items() if str(value.get("tag")) == tag),
    None,
)
if chosen is None:
    focused = state.get("output", {})
    chosen = next(
        (
            key
            for key, value in outputs.items()
            if box(value.get("output", {})) == box(focused)
        ),
        None,
    )
if chosen is None and outputs:
    chosen = next(iter(outputs))
if chosen is None:
    sys.exit(0)

order = sorted(
    outputs,
    key=lambda key: (
        outputs[key].get("output", {}).get("y", 0),
        outputs[key].get("output", {}).get("x", 0),
    ),
)
lines = []
if str(outputs[chosen].get("tag")) != tag:
    lines.append(f"view-tag {chosen} {tag}")
lines.append(f"focus-output {order.index(chosen)}")
lines.append(f"focus-window {identifier}")

try:
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as connection:
        connection.connect(controlPath)
        connection.sendall(("\n".join(lines) + "\n").encode())
except OSError:
    pass
