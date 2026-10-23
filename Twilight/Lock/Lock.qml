import QtQuick
import Quickshell
import Quickshell.Wayland
import Twilight.Core

// The lock screen. Creating it locks the session and asks for the user's
// password through PAM; `unlocked` fires once the right one was typed and the
// compositor has the session back, which is when a process that only exists to
// lock can exit. With `preview` it is a plain overlay on one screen that locks
// nothing and accepts nothing, to try out the look; Esc closes it.
Scope {
    id: root

    property bool preview: false
    // The keyboard layout to show, so a password isn't typed in the wrong one.
    // The compositor is the host's business; empty hides the badge.
    property string layout: ""
    property int layoutIdx: 0

    signal unlocked

    // Cleared once the password was accepted.
    property bool engaged: !preview

    function finish(): void {
        engaged = false;
        // The unlock request has to reach the compositor before the process
        // goes away, or the session stays locked.
        leave.start();
    }

    ConfigFile {
        id: config

        name: "lock"
    }

    Auth {
        id: login

        dry: root.preview
        service: config.get("pam", "login")
        onUnlocked: root.preview ? root.unlocked() : root.finish()
    }

    Timer {
        id: leave

        interval: 300
        onTriggered: root.unlocked()
    }

    WlSessionLock {
        locked: root.engaged

        WlSessionLockSurface {
            color: Theme.bg

            LockScreen {
                anchors.fill: parent
                auth: login
                layout: root.layout
                layoutIdx: root.layoutIdx
            }
        }
    }

    PanelWindow {
        visible: root.preview
        color: Theme.bg
        exclusionMode: ExclusionMode.Ignore

        WlrLayershell.namespace: "twilight-lock-preview"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        LockScreen {
            anchors.fill: parent
            auth: login
            layout: root.layout
            layoutIdx: root.layoutIdx
            onDismissed: root.unlocked()
        }
    }
}
