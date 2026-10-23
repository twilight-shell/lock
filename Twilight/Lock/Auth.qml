import QtQuick
import Quickshell
import Quickshell.Services.Pam

// The password being typed and what PAM says about it. No UI: the screen reads
// `buffer` and `status` and calls the functions on key presses.
Scope {
    id: root

    property string buffer: ""
    // "idle", "checking", "wrong" or "success"
    property string status: "idle"
    // Try the screen out: every password fails and nothing is checked.
    property bool dry: false
    // PAM service to authenticate against, a file in /etc/pam.d.
    property string service: "login"

    signal failed
    signal succeeded
    // After the success animation had time to play.
    signal unlocked

    readonly property bool busy: status === "checking" || status === "success"

    function type(text: string): void {
        if (busy)
            return;
        status = "idle";
        buffer += text;
    }

    function erase(): void {
        if (!busy)
            buffer = buffer.slice(0, -1);
    }

    function clear(): void {
        if (!busy)
            buffer = "";
    }

    function submit(): void {
        if (buffer === "" || busy)
            return;
        if (dry) {
            reject();
            return;
        }
        status = "checking";
        if (!pam.start())
            reject();
    }

    function reject(): void {
        status = "wrong";
        buffer = "";
        failed();
        calmDown.restart();
    }

    PamContext {
        id: pam

        // The system's console login stack by default, which is what swaylock
        // includes too. A config shipped in the repo can't include it: PAM
        // resolves includes inside the custom directory and authentication fails.
        config: root.service

        onResponseRequiredChanged: {
            if (responseRequired)
                respond(root.buffer);
        }

        onCompleted: result => {
            if (result === PamResult.Success) {
                root.status = "success";
                root.succeeded();
                unlockDelay.start();
            } else {
                root.reject();
            }
        }

        onError: root.reject()
    }

    // Let the success animation play before the desktop comes back.
    Timer {
        id: unlockDelay

        interval: 900
        onTriggered: root.unlocked()
    }

    Timer {
        id: calmDown

        interval: 1800
        onTriggered: {
            if (root.status === "wrong")
                root.status = "idle";
        }
    }
}
