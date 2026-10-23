//@ pragma UseQApplication
import QtQuick
import Quickshell
import Twilight.Lock

// `qs -p /path/to/lock/preview.qml` shows the lock screen without locking
// anything, for trying out the look. Any password fails; Esc closes it.
ShellRoot {
    // Optional: without the compositor module there is just no layout badge.
    Loader {
        id: source

        source: "LayoutSource.qml"
    }

    Lock {
        preview: true
        layout: source.item?.layout ?? ""
        layoutIdx: source.item?.layoutIdx ?? 0
        onUnlocked: Qt.quit()
    }
}
