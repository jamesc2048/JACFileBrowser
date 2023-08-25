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
        id: settings

        property bool showPreviewPanel: false
        property bool sortFoldersWithFiles: false
        property bool showIcons: true
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

    component ResizingMenuItem: MenuItem {
        onImplicitWidthChanged: {
            if (menu.contentWidth < implicitWidth) {
                menu.contentWidth = implicitWidth
            }
        }
    }

    menuBar: MenuBar {
        Menu {
            title: "File"

            ResizingMenuItem {
                text: "Open in native file browser"
                onTriggered: utilities.openInNativeBrowser(contentsModel.currentDir)
            }

            ResizingMenuItem {
                text: "Quit"
                onTriggered: Qt.quit()
            }
        }

        Menu {
            title: "View"

            ResizingMenuItem {
                text: "Show Preview panel"
                checkable: true
                checked: settings.showPreviewPanel
                onCheckedChanged: settings.showPreviewPanel = checked
            }

            ResizingMenuItem {
                text: "Sort folders together with files"
                checkable: true
                checked: settings.sortFoldersWithFiles
                onCheckedChanged: settings.sortFoldersWithFiles = checked
            }

            ResizingMenuItem {
                text: "Show icons"
                checkable: true
                checked: settings.showIcons
                onCheckedChanged: settings.showIcons = checked
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
                    break
                case Qt.Key_Up:
                    console.log("TODO select upward")
                    key.accepted = true
                    break
                case Qt.Key_Left:
                    console.log("TODO select left (for grid)")
                    key.accepted = true
                    break;
                case Qt.Key_Right:
                    console.log("TODO select right (for grid)")
                    key.accepted = true
                    break;

            }
        }

        Keys.onReleased: (key) => {
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

                    component NiceToolButton : ToolButton {
                        font.pixelSize: 16
                        hoverEnabled: true
                        ToolTip.visible: hovered
                        ToolTip.delay: 500
                    }

                    NiceToolButton {
                        text: "🡐"
                        onPressed: contentsModel.undo()
                        ToolTip.text: "Undo"
                    }

                    NiceToolButton {
                        text: "🡒"
                        onPressed: contentsModel.redo()
                        ToolTip.text: "Redo"
                    }

                    NiceToolButton {
                        text: "🡑"
                        onPressed: contentsModel.parentDir()
                        ToolTip.text: "Go to parent directory"
                    }

                    NiceToolButton {
                        text: "⟳"
                        onPressed: contentsModel.currentDir = contentsModel.currentDir
                        ToolTip.text: "Reload current directory"
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

                PreviewPanel {
                    SplitView.preferredWidth: 300
                    SplitView.fillHeight: true
                    visible: settings.showPreviewPanel
                }
            }

            NiceLabel {
                Layout.fillWidth: true
                id: footerLabel
                // TODO this needs to change for tabs (1 contentsModel per tab).
                text: `${contentsModel.rows} item${contentsModel.rows != 1 ? "s" : ""}`
                focus: false
            }
        }
    }
}
