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

    Component.onCompleted: {
        // Make it less crazy dark
        if (Universal.theme == Universal.Dark) {
            Universal.background = "#333"
            Universal.foreground = "#eee"
        }

        console.log("Loaded ApplicationWindow Component")
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
    }

    footer: NiceLabel {
        id: footerLabel
        // TODO this needs to change for tabs (1 contentsModel per tab).
        text: `${contentsModel.rows} item`
    }

    header: ToolBar {
        Keys.onPressed: (key) => {
            console.log("toolbar key pressed", key.modifiers, key.key)
            if (key.key == Qt.Key_Control) {
                container.isCtrlPressed = true
            }
        }

        Keys.onReleased:  (key) => {
            console.log("toolbar key released", key.modifiers, key.key)
            if (key.key == Qt.Key_Control) {
                container.isCtrlPressed = false
            }
        }

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
                    // TODO would be nice to remove focus here
                    contentsModel.currentDir = text
                }
            }

            ToolButton {
                text: "Go"
                onClicked: contentsModel.currentDir = currentDirTextField.text
            }
        }
    }

    Item {
        id: container
        anchors.fill: parent
        focus: true

        property bool isCtrlPressed: false

        Keys.onPressed: (key) => {
            console.log("key pressed", key.modifiers, key.key)
            if (key.key == Qt.Key_Control) {
                isCtrlPressed = true
            }
        }

        Keys.onReleased:  (key) => {
            console.log("key released", key.modifiers, key.key)
            if (key.key == Qt.Key_Control) {
                isCtrlPressed = false
            }
        }

        SplitView {
            anchors.fill: parent

            LeftPanel {
                SplitView.preferredWidth: 300
                SplitView.fillHeight: true
            }

            ContentsPanel {
                SplitView.fillWidth: true
                SplitView.fillHeight: true
            }
        }
    }
}
