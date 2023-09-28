import QtQuick
import QtQuick.Controls.Universal

Rectangle {
    property real rowHeight: 30

    id: highlightRect
    color: Universal.theme == Universal.Dark ? "#666" : "#ccc"
    width: parent.width
    height: rowHeight
    visible: false
    z: -1

    Connections {
        target: activeContentsPanel.contentsModel

        function onModelReset() {
            highlightRect.visible = false
        }
    }
}
