import QtQuick
import Twilight.Core

// The current keyboard layout, so a password isn't typed in the wrong one.
Sticker {
    id: root

    property string name: ""
    property int index: 0

    visible: name !== ""
    width: label.implicitWidth + 22
    height: 26
    radius: 13
    lift: 3
    fill: index === 0 ? Theme.secondary : Theme.accent

    StyledText {
        id: label

        anchors.centerIn: parent
        text: root.name
        font.pixelSize: 12
        font.bold: true
    }
}
