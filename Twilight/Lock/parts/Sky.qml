import QtQuick
import QtQuick.Shapes
import Twilight.Core

// The backdrop: a night gradient, stars and a pink glow breathing behind the card.
Item {
    id: root

    // 0 -> 1 as the screen appears.
    property real enter: 0
    // The glow turns pink-red after a wrong password.
    property bool wrong: false
    // Screen y the glow is centered on.
    property real glowY: height / 2

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: Theme.bg }
            GradientStop { position: 0.65; color: "#1f1434" }
            GradientStop { position: 1; color: "#3a1a45" }
        }
    }

    Starfield {
        anchors.fill: parent
        count: 200
        opacity: root.enter
    }

    Shape {
        width: 1400
        height: 1100
        x: (root.width - width) / 2
        y: root.glowY - height / 2
        opacity: root.enter

        SequentialAnimation on scale {
            loops: Animation.Infinite

            NumberAnimation { to: 1.1; duration: 3000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.94; duration: 3000; easing.type: Easing.InOutSine }
        }

        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            startX: 0
            startY: 0

            fillGradient: RadialGradient {
                centerX: 700
                centerY: 550
                centerRadius: 600
                focalX: 700
                focalY: 550

                GradientStop { position: 0; color: Theme.alpha(root.wrong ? Theme.accent : Theme.star, root.wrong ? 0.32 : 0.2) }
                GradientStop { position: 0.55; color: Theme.alpha(Theme.secondary, 0.1) }
                GradientStop { position: 1; color: "transparent" }
            }

            PathLine { x: 1400; y: 0 }
            PathLine { x: 1400; y: 1100 }
            PathLine { x: 0; y: 1100 }
            PathLine { x: 0; y: 0 }
        }
    }
}
