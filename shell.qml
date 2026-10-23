//@ pragma UseQApplication
import QtQuick
import Quickshell
import Twilight.Lock

// Standalone entry: `qs -p /path/to/lock` locks the session and exits once it
// is unlocked. Bind it to a key; nothing needs to keep running in between.
ShellRoot {
    // Optional: without the compositor module there is just no layout badge.
    Loader {
        id: source

        source: "LayoutSource.qml"
    }

    Lock {
        layout: source.item?.layout ?? ""
        layoutIdx: source.item?.layoutIdx ?? 0
        onUnlocked: Qt.quit()
    }
}
