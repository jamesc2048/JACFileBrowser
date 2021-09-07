import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

ApplicationWindow {
    id: window
    width: 1024
    height: 768
    visible: true
    title: "JACFileBrowser"
    //color: "white"

    // Workaround: Tableview has quirk on startup, so delay initial load
    Component.onCompleted: delay(50, function() {
        contentsModel.loadDirectory("C:\\Users\\James Crisafulli\\Downloads");
    })

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

       menuBar: MenuBar {
           Menu {
               title: qsTr("&File")

               //MenuSeparator { }

               Action {
                   text: "&Quit"
                   onTriggered: Qt.quit()
               }
           }
       }

       header: ToolBar {
            RowLayout {
                anchors.fill: parent

                ToolButton {
                    text: "🡐"
                    font.pointSize: 24
                }

                ToolButton {
                    text: "🡒"
                    font.pointSize: 24
                }

                ToolButton {
                    text: "🡑"
                    font.pointSize: 24

                    onClicked: contentsModel.loadDirectory(contentsModel.currentDir + "/..")
                }

                TextField {
                    Layout.fillWidth: true
                    rightInset: 10
                    text: contentsModel.currentDir
                    selectByMouse: true

                    onAccepted: contentsModel.loadDirectory(text)
                }
            }
       }

       SplitView {
           anchors.fill: parent


           ListView {
               id: listView
               SplitView.preferredWidth: 150
               SplitView.fillHeight: true


               boundsBehavior: Flickable.StopAtBounds

               model: drivesModel

               leftMargin: 5
               spacing: 5

               delegate: Label {
                   width: parent.width
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
                       tableView.positionViewAtCell(Qt.point(0, 0), Qt.AlignLeft | Qt.AlignTop,
                                                    Qt.point(-tableView.leftMargin, -columnsHeader.height))
                       contentsModel.loadDirectory(drive);
                   }

                }
           }

            TableView {
                property var columnWidths: [
                    300,    // Name
                    100,    // Size
                    0,      // isDir
                    0,      //
                    200     // last modified
                ]

                id: tableView

                //maximumFlickVelocity: 0

                boundsBehavior: Flickable.StopAtBounds

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

                delegate: Label {
                    text: display
                    elide: Text.ElideRight
                }

                ScrollBar.vertical: ScrollBar {
                    //policy: ScrollBar.AlwaysOn
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
                            tableView.positionViewAtCell(Qt.point(0, 0), Qt.AlignLeft | Qt.AlignTop,
                                                         Qt.point(-tableView.leftMargin, -columnsHeader.height))
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
                            text: tableModelProxy.headerData(modelData, Qt.Horizontal)
                            visible: tableView.columnWidthProvider(modelData) > 0
                            // TODO -5 for the handle?
                            SplitView.preferredWidth: tableView.columnWidthProvider(modelData) - 5
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

//                    Repeater {
//                        model: tableView.columns > 0 ? tableView.columns : 1

//                        Label {
//                            // Hide if column width provider returns 0 (hidden column)
//                            visible: width > 0
//                            width: tableView.columnWidthProvider(modelData)
//                            SplitView.preferredHeight: 35
//                            text: tableModelProxy.headerData(modelData, Qt.Horizontal)
//                            color: '#aaaaaa'
//                            font.pixelSize: 15
//                            padding: 10
//                            verticalAlignment: Text.AlignVCenter

//                            background: Rectangle { color: "#333333" }

//                            // spawn individual mouse areas per header
//                            MouseArea {
//                                anchors.fill: parent
//                                onClicked: console.log("clicked headers", modelData)
//                            }
//                        }
//                    }
                }
            }


        }
}
