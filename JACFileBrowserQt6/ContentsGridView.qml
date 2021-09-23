import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

GridView {
    id: gridView

    anchors.fill: parent

    property int cellsPerRow: Math.trunc(gridView.width / cellWidth)

    model: contentsModel

    boundsBehavior: Flickable.StopAtBounds
    boundsMovement: Flickable.StopAtBounds

    cellWidth: 200
    cellHeight: 200

    flickDeceleration: 5000

    delegate: Item {
        width: gridView.cellWidth - 10
        height: gridView.cellHeight - 10

        ColumnLayout {
            anchors.fill: parent

            Image {
                // TODO proper centering and padding
                Layout.maximumWidth: parent.width - 20
                Layout.fillHeight: true
                source: utils.getLocalUrl(AbsolutePath)
                asynchronous: true
                sourceSize: Qt.size(gridView.cellWidth, gridView.cellHeight)
                autoTransform: true
                fillMode: Image.PreserveAspectFit
                cache: false
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                Layout.maximumWidth: gridView.cellWidth
                text: Name
                wrapMode: Text.WrapAnywhere
                Layout.alignment: Qt.AlignHCenter
            }
        }

        Rectangle {
            // TODO + 5 for the padding?
            width: parent.width + 10
            height: parent.height + 10
            color: "blue"
            opacity: 0.4
            visible: IsSelected
            enabled: IsSelected
        }
    }

    ScrollBar.vertical: ScrollBar {}

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true

        // Add contentX/Y to make it work
        onClicked: {
            const pos = gridView.indexAt(mouse.x + gridView.contentX,
                                         mouse.y + gridView.contentY)

            console.log("single click", pos)

            if (!window.ctrlPressed) {
                console.log("clearsel")
                contentsModel.clearSelection();
            }

            var index = contentsModel.index(pos, 0)
            var isSelected = contentsModel.data(index, Qt.UserRole + 5)
            console.log(isSelected)

            contentsModel.setData(index, !isSelected, Qt.UserRole + 5)
        }

        onPositionChanged: {
            const pos = gridView.indexAt(mouse.x + gridView.contentX,
                                         mouse.y + gridView.contentY)

            //console.log(pos)

            highlightRect.rowPosition = pos
        }

        onExited: highlightRect.rowPosition = -1

        onDoubleClicked: {
            const pos = gridView.indexAt(mouse.x + gridView.contentX,
                                         mouse.y + gridView.contentY)

            if (pos == -1) {
                return;
            }

            const isDir = contentsModel.data(contentsModel.index(pos, 0), Qt.UserRole + 2);
            console.log(isDir)

            if (isDir) {
                const dir = contentsModel.data(contentsModel.index(pos, 0), Qt.UserRole + 3);
                console.log("navigating to folder", dir)

                contentsModel.loadDirectory(dir);
            }
            else {
                const file = contentsModel.data(contentsModel.index(pos, 0), Qt.UserRole + 3);
                console.log("navigating to file", file)

                utils.shellExecute(file)
            }
        }

        onPressed: {
            keyFocus.forceActiveFocus()
            console.log("forceActiveFocus")
        }
    }

    Rectangle {
        property int rowPosition: -1
        property int rowHeight: gridView.cellHeight

        id: highlightRect
        color: "lightblue"

        visible: rowPosition >= 0
        enabled: rowPosition >= 0

        width: gridView.cellWidth
        height: gridView.cellHeight

        // originX / Y is very important here or the rect won't match after resizing
        x: gridView.cellWidth * (rowPosition % gridView.cellsPerRow) - gridView.contentX + gridView.originX
        y: gridView.cellHeight * Math.trunc(rowPosition / gridView.cellsPerRow) - gridView.contentY + gridView.originY
        opacity: 0.4

        Connections {
            target: contentsModel

            function onModelAboutToBeReset() {
                highlightRect.rowPosition = -1
            }
        }
    }
}


