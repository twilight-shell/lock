import QtQuick
import Twilight.Core

// Twilight's star in a ring, with small stars orbiting it; it all speeds up
// while the password is being checked.
Item {
    id: root

    property bool checking: false

    width: 104
    height: 104

    Rectangle {
        id: halo

        anchors.centerIn: parent
        width: parent.width + 8
        height: width
        radius: width / 2
        color: "transparent"
        border.color: Theme.star
        border.width: 3

        ParallelAnimation {
            running: true
            loops: Animation.Infinite

            NumberAnimation { target: halo; property: "scale"; from: 0.95; to: 1.4; duration: 1800; easing.type: Easing.OutCubic }
            NumberAnimation { target: halo; property: "opacity"; from: 0.8; to: 0; duration: 1800; easing.type: Easing.OutCubic }
        }
    }

    Sticker {
        anchors.fill: parent
        radius: width / 2
        lift: 6
        fill: Theme.secondary
    }

    Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 3
        text: "★"
        color: Theme.star
        font.pixelSize: 66
        style: Text.Outline
        styleColor: Theme.ink

        RotationAnimation on rotation {
            running: true
            loops: Animation.Infinite
            from: 0
            to: 360
            duration: root.checking ? 700 : 9000
        }
    }

    Repeater {
        model: 3

        Text {
            required property int index

            property real angle: index * 120

            x: root.width / 2 - width / 2 + Math.cos(angle * Math.PI / 180) * 66
            y: root.height / 2 - height / 2 + Math.sin(angle * Math.PI / 180) * 66
            text: "✦"
            color: index === 1 ? Theme.primary : Theme.text
            font.pixelSize: 14

            NumberAnimation on angle {
                running: true
                loops: Animation.Infinite
                from: index * 120
                to: index * 120 + 360
                duration: root.checking ? 1200 : 6000
            }
        }
    }
}
