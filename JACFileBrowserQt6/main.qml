import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Universal

import Qt.labs.platform as Platform

ApplicationWindow {
    id: window
    width: 1024
    height: 768
    visible: true
    title: "JACFileBrowser " + utils.getApplicationVersion()
    color: Universal.theme == Universal.Dark ? "#333" : "white"

    property bool ctrlPressed: false

    Item {
        id: keyFocus
        anchors.fill: parent

        Keys.onPressed: {
            if (event.key == Qt.Key_Control) {
                window.ctrlPressed = true
            }
        }
        Keys.onReleased: {
            if (event.key == Qt.Key_Control) {
                window.ctrlPressed = false
            }
        }
    }

    // Catchall mousearea
    MouseArea {
        z: 1
        anchors.fill: parent
        propagateComposedEvents: true
        preventStealing: true

        onPressed: {
            keyFocus.forceActiveFocus()
            console.log("forceActiveFocus")
        }
    }

    // Workaround: Tableview has quirk on startup, so delay initial load
    Component.onCompleted: timer.delay(50, function() {
        contentsModel.loadDirectory(utils.getHomePath());
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


       Platform.MenuBar {
           Platform.Menu {
               title: qsTr("&File")

               //MenuSeparator { }

               Platform.MenuItem {
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

           // Catchall for footer
           MouseArea {
               z: 1
               Layout.fillHeight: true
               Layout.fillWidth: true
               propagateComposedEvents: true
               preventStealing: true

               onPressed: {
                   keyFocus.forceActiveFocus()
                   console.log("forceActiveFocus")
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
                   propagateComposedEvents: true

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
