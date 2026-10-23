import QtQuick
import Quickshell
import Twilight.Core

// The password as a row of stars, one per character typed.
Sticker {
    id: root

    property int length: 0
    property bool checking: false
    property bool wrong: false
    // x just after the last star, where the sparks of a key press come from.
    readonly property real tail: stars.x + stars.width + 24

    width: 340
    height: 56
    radius: 28
    lift: 4
    fill: Theme.surfaceHigh
    edge: wrong ? Theme.accent : length > 0 ? Theme.primary : Theme.ink

    StyledText {
        anchors.centerIn: parent
        visible: root.length === 0
        text: root.wrong ? "that spell didn't work" : root.checking ? "" : "type your password ✦"
        color: root.wrong ? Theme.accent : Theme.muted
        font.pixelSize: 15
    }

    Row {
        id: stars

        anchors.centerIn: parent
        spacing: 2

        Repeater {
            model: ScriptModel {
                values: [...Array(Math.min(root.length, 14)).keys()]
            }

            Text {
                id: dot

                required property int index

                text: index % 3 === 1 ? "✦" : "★"
                color: index % 2 === 0 ? Theme.star : Theme.primary
                font.pixelSize: 20
                style: Text.Outline
                styleColor: Theme.ink

                ParallelAnimation {
                    running: true

                    NumberAnimation { target: dot; property: "scale"; from: 0; to: 1; duration: 380; easing.type: Easing.OutBack; easing.overshoot: 3.5 }
                    NumberAnimation { target: dot; property: "rotation"; from: -120; to: 0; duration: 420; easing.type: Easing.OutBack }
                }
            }
        }
    }

    // Spinner while PAM checks the password.
    Text {
        anchors.centerIn: parent
        visible: root.checking
        text: "✦"
        color: Theme.star
        font.pixelSize: 24

        RotationAnimation on rotation {
            running: root.checking
            loops: Animation.Infinite
            from: 0
            to: 360
            duration: 600
        }
    }
}
