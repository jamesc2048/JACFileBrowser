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

    Timer {
        id: timer
    }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

//        GridView {
//            id: gridView
//            Layout.preferredWidth: window.width / 2
//            Layout.fillHeight: true

//            model: listModel

//            cellWidth: 100
//            cellHeight: 100

//            delegate: Text {
//                    width: gridView.cellWidth
//                    height: gridView.cellHeight
//                    text: field1
//                    wrapMode: Text.WrapAnywhere
//                }

//            MouseArea {
//                anchors.fill: parent

//                // Add contentX/Y to make it work
//                onClicked: console.log("clicked gridview cell",
//                                       gridView.indexAt(mouse.x + gridView.contentX,
//                                                        mouse.y + gridView.contentY))

//            }
//        }



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


       SplitView {
           anchors.fill: parent

           ListView {
               id: listView
               SplitView.preferredWidth: 200
               SplitView.fillHeight: true


               boundsBehavior: Flickable.StopAtBounds

               model: drivesModel

               delegate: Label {
                   text: display
               }

               ScrollBar.vertical: ScrollBar{}

               MouseArea {
                   anchors.fill: parent

                   onDoubleClicked: {
                       // Add contentX/Y to make it work when scrolled
                       const clicked = listView.indexAt(mouse.x + listView.contentX,
                                                        mouse.y + listView.contentY)
                       console.log("clicked listview cell", clicked)

                       if (clicked == -1) {
                            return;
                       }

                       // perform navigation
                       const drive = drivesModel.data(drivesModel.index(clicked, 0), Qt.DisplayRole);
                       console.log("navigating to drive", drive)

                       // Workaround...
                       tableView.positionViewAtRow(0, Qt.AlignTop, -35)
                       contentsModel.loadDirectory(drive);
                   }

                }
           }

            TableView {
                id: tableView

                boundsBehavior: Flickable.StopAtBounds

                clip: true
                model: tableModelProxy
                topMargin: columnsHeader.height

                SplitView.fillWidth: true
                SplitView.fillHeight: true

                columnWidthProvider: function(column) {
                    return 300;
                }

                delegate: Label {
                    text: display
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                }
                ScrollBar.horizontal: ScrollBar {}



                MouseArea {
                    anchors.fill: parent

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

                            // Workaround...
                            tableView.positionViewAtRow(0, Qt.AlignTop, -35)
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
                Row {
                    id: columnsHeader
                    // shift it down with the content
                    y: tableView.contentY
                    // stay on top as content scrolls (TableView has z = 1?)
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

                            // spawn individual mouse areas per header
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("clicked headers", modelData)
                            }
                        }
                    }
                }
            }


        }
}
