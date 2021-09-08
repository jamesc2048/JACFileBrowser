import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

GridView {
    id: gridView
    Layout.preferredWidth: window.width / 2
    Layout.fillHeight: true

    model: listModel

    cellWidth: 100
    cellHeight: 100

    delegate: Text {
            width: gridView.cellWidth
            height: gridView.cellHeight
            text: field1
            wrapMode: Text.WrapAnywhere
        }

    MouseArea {
        anchors.fill: parent

        // Add contentX/Y to make it work
        onClicked: console.log("clicked gridview cell",
                               gridView.indexAt(mouse.x + gridView.contentX,
                                                mouse.y + gridView.contentY))

    }
}


