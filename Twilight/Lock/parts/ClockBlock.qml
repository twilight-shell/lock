import QtQuick
import Quickshell
import Twilight.Core

// The big rolling clock with the date and the moon under it.
Column {
    id: root

    readonly property string time: Qt.formatDateTime(clock.date, "HHmm")

    spacing: 10

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            model: 4

            Row {
                required property int index

                RollText {
                    text: root.time[index]
                    color: Theme.text
                    pixelSize: 112
                    bold: true
                    outline: true
                    duration: 600
                }

                Text {
                    visible: index === 1
                    anchors.verticalCenter: parent.verticalCenter
                    text: ":"
                    color: Theme.star
                    font.family: Theme.font
                    font.pixelSize: 112
                    font.bold: true
                    style: Text.Outline
                    styleColor: Theme.ink
                    opacity: clock.date.getSeconds() % 2 === 0 ? 1 : 0.3

                    Behavior on opacity {
                        NumberAnimation { duration: 300 }
                    }
                }
            }
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Qt.locale("en_US").toString(clock.date, "dddd, d MMMM")
        color: Theme.primary
        font.family: Theme.font
        font.pixelSize: 22
        style: Text.Outline
        styleColor: Theme.ink
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Moon {
            width: 24
            height: 24
            anchors.verticalCenter: parent.verticalCenter
            phase: Astro.moonPhase(clock.date)
        }

        StyledText {
            anchors.verticalCenter: parent.verticalCenter
            text: Astro.moonName(Astro.moonPhase(clock.date))
            color: Theme.muted
        }
    }
}
