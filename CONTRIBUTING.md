# Contributing to lock

Thank you for helping. The guide for every repository of the organization is [here](https://github.com/twilight-shell/.github/blob/main/CONTRIBUTING.md): how to propose a change, the commit messages, the checks and the code style. What follows is what is particular to this repository.

## Working on it

- **What it needs:** Twilight.Core, Twilight.Compositor (optional). Clone them next to this one and put their parent folders on `QML_IMPORT_PATH`, separated by `:`, as full paths (not `~`).
- **Run it:** `XDG_CONFIG_HOME=$(mktemp -d) QML_IMPORT_PATH=$HOME/src/core:$HOME/src/lock qs -p preview.qml` (the first part keeps your real settings out of it). **Don't run `qs -p .`: that locks the session for real.** To look at the screen without locking it use `qs -p preview.qml` (any password fails, Esc closes).
- **Tests:** there is no test for the screen: run it and look, and say in the pull request what you tried and on which compositor.
- **Before sending:** run the checks of the guide (`ci/run-tests.sh`, `check-settings.sh`, `check-depends.sh`, `check-install.sh` from the `.github` repository) and add a line to `CHANGELOG.md` under `## Unreleased`.

## Good to know

- **This is the one part that can lock you out of your machine.** Never run `qs -p .` (the real lock) to try a change unless there is a way out: a TTY to switch to (Ctrl+Alt+F2) and a test entry that unlocks by itself after a timer. If the process dies while locked the compositor stays locked.
- The PAM service falls back to `login` in code, on purpose: if the defaults file can't be read the password must still be checked. Don't remove that fallback.
- `Twilight.Compositor` is optional here, through a `Loader`: a missing import in `shell.qml` would stop the screen from locking at all.

For security problems, please don't open an issue: see [SECURITY.md](https://github.com/twilight-shell/.github/blob/main/SECURITY.md).
