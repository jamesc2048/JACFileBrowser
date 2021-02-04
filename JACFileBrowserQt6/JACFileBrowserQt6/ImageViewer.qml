import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

Item {
    property url image

    Image {
        anchors.fill: parent
        source: image

        asynchronous: true
        cache: false
        fillMode: Image.PreserveAspectFit
        transform: [
            Scale {
                id: scaleTransform

                property double scale: 1
                xScale: scale
                yScale: scale
            },
            Translate {
                id: translateTransform

                x: 0
                y: 0
            }

        ]
    }

    MouseArea {
        anchors.fill: parent

        property point initialPosition

        onPressed: initialPosition = Qt.point(mouseX, mouseY)

        onPositionChanged: {
            translateTransform.x = -(initialPosition.x - mouse.x)
            translateTransform.y = -(initialPosition.y - mouse.y)
        }
        onWheel: wheel.angleDelta.y > 0 ? scaleTransform.scale *= 1.25 : scaleTransform.scale /= 1.25
    }
}
