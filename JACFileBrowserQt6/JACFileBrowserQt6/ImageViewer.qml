import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

Item {
    property url imageUrl

    Image {
        id: image
        anchors.fill: parent
        source: imageUrl

        asynchronous: true
        cache: false
        fillMode: Image.PreserveAspectFit
        transform: Scale {
            id: scaleTransform

            property double scale: 1
            xScale: scale
            yScale: scale
            origin.x: image.width / 2
            origin.y: image.height / 2

            function resetScale() {
                scaleTransform.scale = 1
                scaleTransform.origin.x = image.width / 2
                scaleTransform.origin.y = image.height / 2
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        property point initialPosition

        onDoubleClicked: {
            if (scaleTransform.scale > 1) {
                scaleTransform.resetScale()
            }
            else {
                scaleTransform.scale = 2
            }
        }

        onPressed: {
            initialPosition = Qt.point(mouseX, mouseY)
        }

        onPositionChanged: {
            if (scaleTransform.scale < 1.01) {
                return;
            }

            var deltaX = initialPosition.x - mouse.x
            var deltaY = initialPosition.y - mouse.y

            scaleTransform.origin.x += deltaX
            scaleTransform.origin.y += deltaY

            initialPosition = Qt.point(mouse.x, mouse.y)
        }
        onWheel: {
            var scale = wheel.angleDelta.y > 0 ?
                        scaleTransform.scale * 1.25 :
                        scaleTransform.scale / 1.25

            scaleTransform.scale = Math.max(scale, 1)

            if (scale < 1.01) {
                scaleTransform.resetScale()
            }
        }
    }
}
