import QtQuick
import Quickshell
import Twilight.Core
import "parts"

// What the lock screen shows: a night sky, a big rolling clock with the date
// and moon, and a card with Twilight's star, the user name and the password
// typed as a row of stars. A wrong password shakes the card, the right one
// bursts it into sparks before the desktop comes back.
FocusScope {
    id: root

    required property var auth
    property string layout: ""
    property int layoutIdx: 0

    // Esc in a preview, where there is nothing to unlock.
    signal dismissed

    readonly property bool checking: auth.status === "checking"
    readonly property bool wrong: auth.status === "wrong"
    readonly property bool success: auth.status === "success"

    // 0 -> 1 as the screen appears.
    property real enter: 0
    property real shake: 0

    focus: true

    Component.onCompleted: {
        forceActiveFocus();
        enterAnim.restart();
    }

    Connections {
        target: root.auth

        function onFailed() {
            shakeAnim.restart();
        }

        function onSucceeded() {
            const p = avatar.mapToItem(sparks, avatar.width / 2, avatar.height / 2);
            sparks.burst(p.x, p.y, 90);
            leaveAnim.restart();
        }
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            auth.submit();
        } else if (event.key === Qt.Key_Backspace) {
            if (event.modifiers & Qt.ControlModifier)
                auth.clear();
            else
                auth.erase();
        } else if (event.key === Qt.Key_Escape) {
            if (auth.dry)
                dismissed();
            else
                auth.clear();
        } else if (event.text.length > 0 && event.text.charCodeAt(0) >= 32) {
            auth.type(event.text);
            const p = field.mapToItem(sparks, field.tail, field.height / 2);
            sparks.burst(p.x, p.y, 4);
        } else {
            return;
        }
        event.accepted = true;
    }

    NumberAnimation {
        id: enterAnim

        target: root
        property: "enter"
        from: 0
        to: 1
        duration: 1100
        easing.type: Easing.OutCubic
    }

    SequentialAnimation {
        id: shakeAnim

        NumberAnimation { target: root; property: "shake"; to: -22; duration: 50 }
        NumberAnimation { target: root; property: "shake"; to: 20; duration: 80 }
        NumberAnimation { target: root; property: "shake"; to: -14; duration: 70 }
        NumberAnimation { target: root; property: "shake"; to: 9; duration: 60 }
        NumberAnimation { target: root; property: "shake"; to: 0; duration: 200; easing.type: Easing.OutBack }
    }

    SequentialAnimation {
        id: leaveAnim

        NumberAnimation { target: card; property: "scale"; to: 1.08; duration: 140; easing.type: Easing.OutQuad }
        ParallelAnimation {
            NumberAnimation { target: card; property: "scale"; to: 0.3; duration: 380; easing.type: Easing.InBack; easing.overshoot: 2 }
            NumberAnimation { target: card; property: "opacity"; to: 0; duration: 380 }
            NumberAnimation { target: root; property: "enter"; to: 0; duration: 760; easing.type: Easing.InCubic }
        }
    }

    Sky {
        anchors.fill: parent
        enter: root.enter
        wrong: root.wrong
        glowY: card.y + card.height / 2
    }

    ClockBlock {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * 0.12 - (1 - root.enter) * 60
        opacity: root.enter
    }

    Item {
        id: card

        width: 440
        // The column starts above the card (the avatar pokes out of its top).
        height: content.height + content.y + 30
        x: (root.width - width) / 2 + root.shake
        y: root.height * 0.5 - 40 + (1 - root.enter) * 120

        Sticker {
            anchors.fill: parent
            radius: 28
            lift: 10
            fill: Theme.surface
            edge: root.wrong ? Theme.accent : Theme.ink
        }

        Column {
            id: content

            anchors.horizontalCenter: parent.horizontalCenter
            y: -48
            spacing: 14

            Avatar {
                id: avatar

                anchors.horizontalCenter: parent.horizontalCenter
                checking: root.checking
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Quickshell.env("USER")
                color: Theme.text
                font.family: Theme.font
                font.pixelSize: 24
                font.bold: true
                style: Text.Outline
                styleColor: Theme.ink
            }

            PasswordField {
                id: field

                anchors.horizontalCenter: parent.horizontalCenter
                length: root.auth.buffer.length
                checking: root.checking
                wrong: root.wrong
            }

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.checking ? "casting the unlock spell..."
                    : root.success ? "welcome back ✦"
                    : root.auth.buffer.length > 14 ? root.auth.buffer.length + " characters"
                    : "enter unlocks · esc clears"
                color: root.success ? Theme.star : Theme.muted
                font.pixelSize: 12
            }

            LayoutBadge {
                anchors.horizontalCenter: parent.horizontalCenter
                name: root.layout
                index: root.layoutIdx
            }
        }
    }

    StyledText {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        opacity: root.enter * 0.8
        text: "✧ Twilight is guarding this session ✧"
        color: Theme.muted
        font.pixelSize: 13
    }

    SparkleBurst {
        id: sparks

        anchors.fill: parent
    }
}
