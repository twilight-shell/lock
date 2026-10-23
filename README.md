# twilight-shell/lock

The lock screen of the [twilight-shell](https://github.com/twilight-shell)
organization: a night sky, a rolling clock with the date and the moon, and a card
where the password is typed as a row of stars. It locks the session with the
`ext-session-lock` protocol and checks the password through PAM.

It is a process of its own, like swaylock: it starts when you lock, and exits
once you unlock. Nothing of it runs in between, and restarting or crashing the
shell can't touch a lock that is up.

## Requirements

[Quickshell](https://quickshell.org) 0.3 or newer, a compositor that supports
`ext-session-lock-v1`, and
[twilight-shell/core](https://github.com/twilight-shell/core) installed.
[twilight-shell/compositor](https://github.com/twilight-shell/compositor) is
optional: it only supplies the keyboard layout badge, and without it the screen
simply has none.

## Running

```sh
qs -p /path/to/lock                    # locks the session
qs -p /path/to/lock/preview.qml        # shows the screen, locks nothing
```

Bind the first one to a key. With niri:

```kdl
Mod+Alt+Shift+L { spawn "qs" "-p" "/path/to/lock" "--no-duplicate"; }
```

`--no-duplicate` keeps a second press from starting a second locker.

If the locker dies while the session is locked, the compositor keeps it locked.
Switch to a TTY (Ctrl+Alt+F2), log in and start another locker, or `pkill`
the old one's leftovers.

If the modules are not in a directory Qt searches, point `QML_IMPORT_PATH` at
their parent directories, separated by `:`.

## Using it in your own shell

```sh
sudo make install        # to /usr/lib/qt6/qml/Twilight/Lock
```

```qml
import Twilight.Lock

Lock {
    layout: "us"          // shown in a badge; empty hides it
    layoutIdx: 0
    onUnlocked: Qt.quit()
}
```

Creating a `Lock` locks the session. With `preview: true` it shows the screen
on one output and locks nothing.

## Settings

`~/.config/twilight-shell/lock.toml`, created with the defaults the first time the
lock starts:

```toml
# The PAM service the password is checked against, a file in /etc/pam.d.
pam = "login"
```

The colors come from `~/.config/twilight-shell/theme.toml` (see
[core](https://github.com/twilight-shell/core)).

## License

MIT, see `LICENSE`.
