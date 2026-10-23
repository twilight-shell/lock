# AGENTS.md

For AI coding agents working in this repository; humans may find it a quick orientation. The full guide is [CONTRIBUTING.md](CONTRIBUTING.md) and [the organization's](https://github.com/twilight-shell/.github/blob/main/CONTRIBUTING.md).

## What this is

The lock screen: a process of its own that locks the session (`ext-session-lock-v1`), checks the password through PAM, and exits when unlocked.

It is one repository of [twilight-shell](https://github.com/twilight-shell), a Wayland desktop shell made of independent repositories. It needs: Twilight.Core, Twilight.Compositor (optional).

## Layout

- `Twilight/Lock/Lock.qml`: the session lock and the preview window; `Auth.qml`: the password and PAM; `LockScreen.qml` and `parts/`: what is drawn
- `shell.qml`: locks and quits when unlocked; `preview.qml`: shows the screen without locking; `LayoutSource.qml`: the optional keyboard layout
- `Twilight/Lock/lock.defaults.toml` and `.schema.toml`: the settings (the PAM service)
- `DEPENDS`: the modules it needs; `CHANGELOG.md`; `Makefile` (`make install`)

## Run and check it

```sh
XDG_CONFIG_HOME=$(mktemp -d) QML_IMPORT_PATH=$HOME/src/core:$HOME/src/lock qs -p preview.qml
```

**Don't run `qs -p .`: that locks the session for real.** To look at the screen without locking it use `qs -p preview.qml` (any password fails, Esc closes).

There are no automated tests for what is drawn: run it, look at it, and say what you tried.

The checks CI runs are scripts in the [`.github` repository](https://github.com/twilight-shell/.github/tree/main/ci); run them before you push.

## Rules

- Work on a branch (`feat/...`, `fix/...`, `docs/...`); never commit to or push `main`. Changes land through a pull request.
- Commit messages are `type: Subject` (`feat`, `fix`, `docs`, `test`, `ci`, `chore`, `refactor`), imperative, capitalized, no full stop.
- One change per pull request, small. Update the `CHANGELOG.md` (`## Unreleased`), the README, and `DEPENDS` if you import another `Twilight.*` module.
- **Defaults live in one place:** `<name>.defaults.toml`. Never repeat a default in code.
- **A component doesn't know the others:** what it needs comes in as properties and signals, set by the shell. Don't import another component to reach into it.
- Don't add a dependency without asking. Comments say why, not what; English; match the style around.

## Be careful

- **Use a throwaway settings folder** while you try things: `XDG_CONFIG_HOME=$(mktemp -d)`. Don't write to the user's `~/.config/twilight-shell/`.
- **Don't match your own command with `pkill -f` or `pgrep -f`:** a pattern that is in the command line of the shell that runs it kills that shell. Use `pgrep -x qs`, or `qs -p <path> kill`.
- A screenshot of the whole screen shows whatever windows are open. Take them on an empty workspace, and don't publish what isn't yours.
- Don't run the real lock screen without a way out (a TTY, and a timer that unlocks); see the `lock` repository.

## This repository

- **This is the one part that can lock you out of your machine.** Never run `qs -p .` (the real lock) to try a change unless there is a way out: a TTY to switch to (Ctrl+Alt+F2) and a test entry that unlocks by itself after a timer. If the process dies while locked the compositor stays locked.
- The PAM service falls back to `login` in code, on purpose: if the defaults file can't be read the password must still be checked. Don't remove that fallback.
- `Twilight.Compositor` is optional here, through a `Loader`: a missing import in `shell.qml` would stop the screen from locking at all.

## QML and Quickshell gotchas

- Typed properties (`string`, `bool`, `real`) see `undefined` at startup until a defaults file is read; coerce with `!!x`, `Number(x)` or `x ?? ""` rather than repeating the default.
- In a function with typed parameters QML wants a return type too (`function f(a: string): void`); without it a returned value is an error.
- An `id` can hide a property of the same name: `auth: auth` is a property bound to itself. Give ids names that don't repeat a property.
- `Process` and `FileView` are asynchronous; whatever reads their result has to wait for it.
- Quickshell loads the config again when a file of the config changes, but QML Qt has already loaded from elsewhere is cached, and the list of module folders is read once, at start.
- A `Row` doesn't use `implicitWidth`: give the items a `width`, or they have none.
