import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

Item {
    property url imageUrl
    property var stackView
    focus: true

    ColumnLayout {
        anchors.fill: parent

        ToolBar {
            id: toolBar

            Layout.fillWidth: true

             RowLayout {
                 id: toolRow
                 anchors.fill: parent

                 Label {
                     Layout.fillWidth: true
                     text: imageUrl
                 }

                 ToolButton {
                     text: "CenterIcon"
                     onClicked: scaleTransform.resetScale()
                 }

                 ToolButton {
                     text: "Zoom+Icon"
                     onClicked: stackView.pop()
                 }

                 ToolButton {
                     text: "Zoom-Icon"
                     onClicked: stackView.pop()
                 }

                 ToolButton {
                     text: "Close"
                     onClicked: {
                         scaleTransform.resetScale()
                         stackView.pop()
                     }
                 }
             }
         }

        Image {
            id: image
            Layout.fillWidth: true
            Layout.fillHeight: true
            source: imageUrl
            z: -1

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
                    scale = 1
                    origin.x = image.width / 2
                    origin.y = image.height / 2
                }

                function zoom(zoomIn) {
                    var scale = zoomIn ?
                                scaleTransform.scale * 1.25 :
                                scaleTransform.scale / 1.25

                    scaleTransform.scale = Math.max(scale, 1)

                    if (scale < 1.01) {
                        resetScale()
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
                    if (wheel.angleDelta.y > 0) {
                        scaleTransform.zoom(true)
                    }
                    else {
                        scaleTransform.zoom(false)
                    }
                }
            }
        }
    }
}
