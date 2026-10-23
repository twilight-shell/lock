import QtQuick
import Twilight.Compositor

// The keyboard layout from the compositor module. Kept in a file of its own so
// the lock screen is loaded without it: a Loader that fails to find the module
// only logs an error, whereas a missing import in shell.qml would stop the
// whole screen from locking.
QtObject {
    readonly property string layout: Compositor.layout
    readonly property int layoutIdx: Compositor.layoutIdx
}
