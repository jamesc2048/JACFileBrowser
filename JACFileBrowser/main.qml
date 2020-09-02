import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    width: 1024
    height: 768
    visible: true
    title: "JACFileExplorer"

    menuBar: MenuBar {
        Menu {
            title: "File"

            Action {
                text: "New Tab"
                shortcut: "Ctrl+T"
                onTriggered: backend.newTab(tabBar.currentIndex)
            }

            Action {
                text: "Close Tab"
                shortcut: "Ctrl+W"
                onTriggered: {
                    backend.closeTab(tabBar.currentIndex)

                    if (backend.tabsModel.rowCount() <= 0) {
                        Qt.quit();
                    }
                }
            }

            MenuSeparator { }

            Action {
                text: "Quit"
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }

        Menu {
            title: "View"

            Action {
                text: "Increase cell size"

                onTriggered: {
                    props.cellWidth *= 1.2
                    props.cellHeight *= 1.2
                }
            }

            Action {
                text: "Decrease cell size"

                onTriggered: {
                    props.cellWidth /= 1.2
                    props.cellHeight /= 1.2
                }
            }
        }
    }

    // TODO write to QSettings
    QtObject {
        id: props

        property int cellWidth: 100
        property int cellHeight: 100
    }

    ColumnLayout {
        id: mainLayout

        anchors.fill: parent

        TabBar {
            id: tabBar
            Layout.fillWidth: true

            Repeater {
                model: backend.tabsModel

                delegate: TabButton {
                    text: contentsModel.path
                }
            }
        }

        StackLayout {
            currentIndex: tabBar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: backend.tabsModel

                delegate: ColumnLayout {
                    ToolBar {
                        Layout.fillWidth: true

                        RowLayout {
                             anchors.fill: parent

                             ToolButton {
                                 text: "<"
                                 onClicked: stack.pop()
                             }

                             ToolButton {
                                 text: ">"
                                 onClicked: stack.pop()
                             }

//                             Label {
//                                 text: path
//                                 elide: Label.ElideRight
//                                 horizontalAlignment: Qt.AlignHCenter
//                                 verticalAlignment: Qt.AlignVCenter
//                                 Layout.fillWidth: true
//                             }

                             TextField {
                                 Layout.fillWidth: true

                                 text: contentsModel.path
                                 //horizontalAlignment: Qt.AlignHCenter
                                 verticalAlignment: Qt.AlignVCenter

                                 Keys.onPressed: {
                                     switch (event.key) {
                                         // enter = keypad enter, return = normal enter
                                        case Qt.Key_Enter:
                                        case Qt.Key_Return:
                                            console.log("Key pressed", text, event.key, Qt.Key_Enter)

                                            contentsModel.path = text
                                     }
                                 }
                             }
                         }
                    }

                    GridView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        id: gridView

                        clip: true
                        flickableDirection: Flickable.VerticalFlick
                        boundsBehavior: Flickable.StopAtBounds
                        ScrollBar.vertical: ScrollBar {}

                        model: contentsModel

                        cellWidth: props.cellWidth
                        cellHeight: props.cellHeight

                        delegate: Rectangle {
                            id: rect

                            clip: true

                            border {
                                color: "black"
                                width: 1
                            }

                            color: isSelected ? "lightsteelblue" :
                                                mouseArea.containsMouse ? "lightgray" : "white"

                            radius: 5

                            width: gridView.cellWidth - 10
                            height: gridView.cellHeight - 10

                            ColumnLayout {
                                width: rect.width
                                height: rect.height

                                Image {
                                    Layout.topMargin: 5
                                    Layout.preferredWidth: rect.width
                                    Layout.preferredHeight: rect.height / 2

                                    fillMode: Image.PreserveAspectFit
                                    source: isFolder ? "qrc:/icons/folderIcon.png" : "qrc:/icons/fileIcon.png"
                                    // NOTE: set to false when using the real preview
                                    cache: true
                                }

                                Text {
                                    Layout.fillHeight: true
                                    Layout.maximumWidth: rect.width
                                    Layout.margins: 5
                                    Layout.alignment: Qt.AlignHCenter

                                    renderType: Text.NativeRendering
                                    wrapMode: Text.Wrap
                                    text: name
                                }

                                Popup {
                                    id: popup
                                     //x: 100
                                     y: rect.height
                                     //width: 200
                                     //height: 300
                                     //modal: true
                                     //focus: true
                                     //closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                                     visible: mouseArea.containsMouse

                                    contentItem: Text {
                                        renderType: Text.NativeRendering
                                        wrapMode: Text.Wrap
                                        text: name
                                    }
                                }
                            }

                            MouseArea {
                                id: mouseArea
                                hoverEnabled: true
                                anchors.fill: parent

                                onDoubleClicked: {
                                    // May open file or change dir.
                                    backend.openAction(tabBar.currentIndex, index)
                                }

                                onClicked: {
                                    //listView.currentIndex = index
                                    //if (view.ctrlPressed) {
                                    isSelected = !isSelected
                                    //}
    //                                else {
    //                                    view.model.setSelected(index, !isSelected)
    //                                }

                                    console.log("switch selected " + index, tabBar.currentIndex, isSelected)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
