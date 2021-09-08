import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Qt.labs.qmlmodels

TableView {
    id: tableView

    property var columnWidths: [
        300,    // Name
        100,    // Size
        0,      // isDir
        0,      // absolute path
        300,    // last modified
        0,      // isSelected
    ]

    function resetView() {
        tableView.positionViewAtCell(Qt.point(0, 0), Qt.AlignLeft | Qt.AlignTop,
                                     Qt.point(-tableView.leftMargin, -columnsHeader.height))
    }

    boundsBehavior: Flickable.StopAtBounds
    boundsMovement:  Flickable.StopAtBounds

    // to make it be more like desktop scrolling
    flickDeceleration: 10000

    columnSpacing: 5

    leftMargin: 5

    clip: true
    model: tableModelProxy
    topMargin: columnsHeader.height

    SplitView.fillWidth: true
    SplitView.fillHeight: true

    columnWidthProvider: function(column) {
        const colWidth = columnWidths[column]

        if (colWidth === undefined) {
            return 300
        }

        return colWidth
    }

    rowHeightProvider: function(row) {
        return 25;
    }

    delegate: DelegateChooser {
        component LabelComponent : Label {
            text: display
            elide: Text.ElideRight
        }

        component SelectionRectangleComponent : Rectangle {
            width: parent.width + 5
            height: parent.height
            color: "blue"
            opacity: 0.5
            visible: IsSelected
            enabled: IsSelected
            x: -5
        }

        DelegateChoice {
            column: 0

            Item {
                RowLayout {
                    width: parent.width

                    Label {
                        text: IsDir ? "📁" : ""
                        Layout.preferredWidth: 20
                    }

                    LabelComponent {
                        Layout.fillWidth: true
                    }
                }

                SelectionRectangleComponent {}
            }
        }

        DelegateChoice {
            column: 1

            Item {
                LabelComponent {
                    horizontalAlignment: Text.AlignRight
                }

                SelectionRectangleComponent {}
            }
        }

        DelegateChoice {
            column: 2

            Item {
                LabelComponent {}
                SelectionRectangleComponent {}
            }
        }

        DelegateChoice {
            column: 3

            Item {
                LabelComponent {}
                SelectionRectangleComponent {}
            }
        }

        DelegateChoice {
            column: 4

            Item {
                LabelComponent {}
                SelectionRectangleComponent {}
            }
        }

        DelegateChoice {
            column: 5

            Item {
                LabelComponent {}
                SelectionRectangleComponent {}
            }
        }
    }

    ScrollBar.vertical: ScrollBar {
        //policy: ScrollBar.AlwaysOn
    }
    ScrollBar.horizontal: ScrollBar {}

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true

        onPositionChanged: {
            const pos = tableView.cellAtPos(mouse.x - tableView.contentX,
                                            mouse.y - tableView.contentY,
                                            true);

            highlightRect.rowPosition = pos.y
        }

        onExited: highlightRect.rowPosition = -1

        onClicked: {
            // Unlike gridView, subtract contentX/Y to make it work
            const pos = tableView.cellAtPos(mouse.x - tableView.contentX,
                                            mouse.y - tableView.contentY,
                                            true);

            console.log("single click", pos)

            var index = contentsModel.index(pos.y, 0)
            var isSelected = contentsModel.data(index, Qt.UserRole + 5)
            console.log(isSelected)

            contentsModel.setData(index, !isSelected, Qt.UserRole + 5)
        }

        onDoubleClicked: {
            // Unlike gridView, subtract contentX/Y to make it work
            const pos = tableView.cellAtPos(mouse.x - tableView.contentX,
                                            mouse.y - tableView.contentY,
                                            true);

            console.log("clicked tableview cell", pos)

            if (pos == Qt.point(-1, -1)) {
                return;
            }

            const isDir = contentsModel.data(contentsModel.index(pos.y, 0), Qt.UserRole + 2);
            console.log(isDir)

            if (isDir) {
                const dir = contentsModel.data(contentsModel.index(pos.y, 0), Qt.UserRole + 3);
                console.log("navigating to folder", dir)

                contentsModel.loadDirectory(dir);
            }
            else {
                const file = contentsModel.data(contentsModel.index(pos.y, 0), Qt.UserRole + 3);
                console.log("navigating to file", file)

                utils.shellExecute(file)
            }
        }
    }

    // https://stackoverflow.com/questions/55610163/how-to-create-a-tableview-5-12-with-column-headers
    // note that HorizontalHeaderView is not good enough for this
    SplitView {
        id: columnsHeader
        // shift it down with the content
        y: tableView.contentY
        // stay on top as content scrolls (TableView has z = 1?)
        z: 2
        height: 35
        width: parent.width

        onResizingChanged: {
            if (!resizing) {
                // for-of loop doesn't work?
                for (var i = 0; i < columnsHeader.contentChildren.length; i++) {
                    const child = columnsHeader.contentChildren[i];

                    if (child.visible) {
                        console.log(child.text, child.width)

                        // TODO empirically determined
                        var childWidth = child.width + 5;

                        if (i == columnsHeader.contentChildren.length - 1) {
                            // TODO -8 empirically determined
                            childWidth = child.width - 8
                        }

                        tableView.columnWidths[i] = childWidth;
                    }
                }

                //console.log(columnsHeader.saveState())

                // reload column widths
                tableView.forceLayout()
            }
        }

        Repeater {
            // Workaround for columns being 0 in the beginning
            model: tableView.columns > 0 ? tableView.columns : 1

            Label {
                property int columnWidth: tableView.columnWidthProvider(modelData)

                text: tableModelProxy.headerData(modelData, Qt.Horizontal)
                visible: columnWidth > 0
                // TODO -5 for the handle?
                SplitView.preferredWidth: columnWidth - 5
                SplitView.minimumWidth: 75

                color: '#aaaaaa'
                font.pixelSize: 15
                padding: 10
                verticalAlignment: Text.AlignVCenter
                background: Rectangle { color: "#333333" }
                elide: Text.ElideRight

                // compensate for table margin for leftmost
                leftInset: modelData == 0 ? -tableView.leftMargin : 0

                // spawn individual mouse areas per header
                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("clicked headers", modelData)
                }
            }
        }
    }

    Rectangle {
        property int rowPosition: -1
        property int rowHeight: tableView.rowHeightProvider(0)

        id: highlightRect
        color: "lightblue"

        visible: rowPosition >= 0
        enabled: rowPosition >= 0

        width: tableView.contentWidth
        height: rowHeight

        y: rowHeight * rowPosition
        opacity: 0.5

        Connections {
            target: contentsModel

            function onModelAboutToBeReset() {
                highlightRect.rowPosition = -1
            }
        }
    }
}

// for reference
//HorizontalHeaderView {
//    id: headerView
//    syncView: tableView
//    clip: true

//    Layout.fillWidth: true

//    MouseArea {
//        anchors.fill: parent
//        onClicked: console.log("sort?", mouse.x, mouse.y, headerView.cellAtPos(mouse.x, mouse.y, true))
//    }
//}
