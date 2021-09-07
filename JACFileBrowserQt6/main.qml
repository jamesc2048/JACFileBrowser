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
    Component.onCompleted: timer.delay(50, function() {
        contentsModel.loadDirectory("C:\\Users\\James Crisafulli\\Downloads");
    })

    Timer {
        id: timer

        function delay(delayTime, cb) {
            timer.interval = delayTime;
            timer.repeat = false;
            timer.triggered.connect(cb);
            timer.start();
        }
    }

    Connections {
        target: contentsModel

        function onModelAboutToBeReset() {
            // Workaround for Qt quirk...
            tableView.resetView()
        }

        function onModelReset() {
            // I don't think I can bind this directly? Would have to make a QProperty?
            contentsCountLabel.contentsCount = contentsModel.rowCount()
        }
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

       footer: RowLayout {
           height: 30
           width: parent.width

           Label {
               property int contentsCount

               id: contentsCountLabel
               leftPadding: 5
               text: `${contentsCount} item${contentsCount != 1 ? "s" : ""}`
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

                       contentsModel.loadDirectory(drive);
                   }

                }
           }

           ContentsTableView {
               id: tableView
           }
        }
}
