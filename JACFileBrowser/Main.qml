import QtCore
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform as Labs
import QtQuick.Controls.Universal

import JACFileBrowser

ApplicationWindow {
    id: window
    width: 1024
    height: 768
    visible: true
    title: "JAC File Browser"

    Universal.theme: Universal.System

    Settings {
        property bool showPreviewPanel

        id: settings
    }

    Component.onCompleted: {
        // Make it less crazy dark
        if (Universal.theme == Universal.Dark) {
            Universal.background = "#333"
            Universal.foreground = "#eee"
        }

        console.log("Loaded ApplicationWindow Component")
    }

    Component.onDestruction: {
        settings.sync()

        console.log("Destroying ApplicationWindow Component")
    }

    Shortcut {
       sequences: [ StandardKey.Cut ]
       onActivated: console.log("TODO cut")
    }

    Shortcut {
       sequences: [ StandardKey.Copy ]
       onActivated: console.log("TODO copy")
    }

    Shortcut {
       sequences: [ StandardKey.Paste ]
       onActivated: console.log("TODO paste")
    }

    Shortcut {
       sequences: [ StandardKey.Undo ]
       onActivated: console.log("TODO undo")
    }

    Shortcut {
       sequences: [ StandardKey.Redo, "Ctrl+Shift+Z" ]
       onActivated: console.log("TODO redo")
    }

    Shortcut {
       sequences: [ StandardKey.SelectAll ]
       onActivated: {
           console.log("TODO select all")
       }
    }

    Shortcut {
       sequences: [ StandardKey.Find ]
       onActivated: console.log("TODO find")
    }

    Shortcut {
       sequences: [ "Ctrl+L" ]
       onActivated: {
           currentDirTextField.forceActiveFocus()
           currentDirTextField.selectAll()
       }
    }

    Shortcut {
       sequences: [ "Ctrl+W" ]
       onActivated: {
           // When tabs are implemented, quit tab
           Qt.quit()
       }
    }

    // Global
    Utilities {
        id: utilities
    }

    DrivesModel {
        id: drivesModel
    }

    // Move this into ContentsPanel.qml when tabs are implemented
    ContentsModel {
        id: contentsModel
        currentDir: "C:\\SDK\\Qt"
    }
//    TestDrivesModel {
//        id: drivesModel
//    }

//    Labs.MenuBar {
//        Labs.Menu {
//            title: "File"

//            Labs.MenuItem {
//                text: "Open in native file browser"
//                onTriggered: utilities.openInNativeBrowser(contentsModel.currentDir)
//            }
//            Labs.MenuItem {
//                text: "Quit"
//                onTriggered: Qt.quit()
//            }
//        }
//    }

    menuBar: MenuBar {
        Menu {
            title: "File"

            Action {
                text: "Open in native file browser"
                onTriggered: utilities.openInNativeBrowser(contentsModel.currentDir)
            }

            Action {
                text: "Quit"
                onTriggered: Qt.quit()
            }
        }

        Menu {
            title: "View"

            Action {
                text: "Show Preview panel"
                checkable: true
                checked: settings.showPreviewPanel
                onCheckedChanged: settings.showPreviewPanel = checked
            }
        }
    }

    Item {
        id: container
        anchors.fill: parent
        focus: true

        property bool isCtrlPressed: false
        property bool isShiftPressed: false

        Keys.onPressed: (key) => {
            switch (key.key) {
                case Qt.Key_Control:
                    // Control held down on its own
                    console.log("Ctrl key pressed")
                    isCtrlPressed = true
                    break
                case Qt.Key_Shift:
                    console.log("Shift key pressed")
                    isShiftPressed = true
                    break
                case Qt.Key_Down:
                    console.log("TODO select downward")
                    key.accepted = true
                    break;
                case Qt.Key_Up:
                    console.log("TODO select upward")
                    key.accepted = true
                    break;

            }
        }

        Keys.onReleased:  (key) => {
            switch (key.key) {
                case Qt.Key_Control:
                    console.log("Ctrl key released")
                    isCtrlPressed = false
                    break
                case Qt.Key_Shift:
                    console.log("Shift key released")
                    isShiftPressed = false
                    break
            }
        }

        ColumnLayout {
            anchors.fill: parent

            ToolBar {
                Layout.fillWidth: true

                RowLayout {
                    anchors.fill: parent

                    ToolButton {
                        text: "🡐"
                        onPressed: contentsModel.undo()
                    }
                    ToolButton {
                        text: "🡒"
                        onPressed: contentsModel.redo()
                    }
                    ToolButton {
                        text: "🡑"
                        onPressed: contentsModel.parentDir()
                    }

                    TextField {
                        id: currentDirTextField
                        Layout.fillWidth: true
                        text: contentsModel.currentDir
                        onAccepted: {
                            contentsModel.currentDir = text
                            container.forceActiveFocus()
                        }
                    }

                    ToolButton {
                        text: "Go"
                        onClicked: {
                            contentsModel.currentDir = currentDirTextField.text
                            container.forceActiveFocus()
                        }
                    }
                }
            }

            SplitView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                LeftPanel {
                    SplitView.preferredWidth: 300
                    SplitView.fillHeight: true
                }

                ContentsPanel {
                    SplitView.fillWidth: true
                    SplitView.fillHeight: true
                }

                Loader {
                    visible: settings.showPreviewPanel
                    SplitView.preferredWidth: 300
                    SplitView.fillHeight: true

                    // Types of preview?
                    // Image, Video, Text, more?
                    // TODO Load suitable component to view
                    // Also need to be able to find out the current selected item
                    // Maybe driven by file extension of selected file?
                    sourceComponent: NiceLabel {
                        text: "Preview Panel"
                    }
                }
            }

            NiceLabel {
                Layout.fillWidth: true
                id: footerLabel
                // TODO this needs to change for tabs (1 contentsModel per tab).
                text: `${contentsModel.rows} item`
                focus: false
            }
        }
    }
}
