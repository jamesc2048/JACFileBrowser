import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

Window {
    id: window
    width: 1024
    height: 768
    visible: true
    title: "JACFileBrowser"

    RowLayout {
       anchors.fill: parent

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
        }



//            HorizontalHeaderView {
//                id: headerView
//                syncView: tableView
//                clip: true

//                Layout.fillWidth: true

//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: console.log("sort?", mouse.x, mouse.y, headerView.cellAtPos(mouse.x, mouse.y, true))
//                }
//            }


            TableView {
                id: tableView

                clip: true
                model: tableModelProxy
                topMargin: columnsHeader.height

                Layout.preferredWidth: window.width / 2
                Layout.fillHeight: true

                columnWidthProvider: function(column) {
                    return 100;
                }

                delegate: Text {
                    text: display
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("cell", tableView.cellAtPos(mouse.x, mouse.y, true))
                }

                // https://stackoverflow.com/questions/55610163/how-to-create-a-tableview-5-12-with-column-headers
                Row {
                    id: columnsHeader
                    // shift it down with the content
                    y: tableView.contentY
                    // stay on top as content scrolls
                    z: 2

                    // Note: this is slow for big headers as these stay loaded
                    Repeater {
                        model: tableView.columns > 0 ? tableView.columns : 1

                        Label {
                            width: tableView.columnWidthProvider(modelData)
                            height: 35
                            text: tableModelProxy.headerData(modelData, Qt.Horizontal)
                            color: '#aaaaaa'
                            font.pixelSize: 15
                            padding: 10
                            verticalAlignment: Text.AlignVCenter

                            background: Rectangle { color: "#333333" }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("sort?", mouse.x, mouse.y, modelData)
                            }
                        }
                    }
                }
            }

    }
}
