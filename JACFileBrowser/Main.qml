import JACFileBrowser
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform as Labs

import QtQuick.Controls.Universal

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

    component NiceLabel: Label {
        clip: true
        elide: Text.ElideRight
        padding: 5
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

    // Global
    Utilities {
        id: utilities
    }

    // Per tab
    ContentsModel {
        id: contentsModel
        currentDir: "C:\\SDK\\Qt"
    }

    DrivesModel {
        id: drivesModel
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

    SplitView {
        anchors.fill: parent

        ListView {
            SplitView.preferredWidth: 300
            SplitView.fillHeight: true
            clip: true
            flickDeceleration: 10000

            delegate: NiceLabel {
                text: display
            }

            boundsBehavior: Flickable.StopAtBounds
            model: drivesModel

            ScrollBar.vertical: ScrollBar {
                //policy: ScrollBar.AlwaysOn
            }

            NiceLabel {
                width: parent.width
                horizontalAlignment: Qt.AlignHCenter
                text: "Loading..."
                visible: drivesModel.rows == 0
            }
        }

        ColumnLayout {
            spacing: 0
            SplitView.fillWidth: true
            SplitView.fillHeight: true

            HorizontalHeaderView {
                Layout.fillWidth: true
                syncView: tableView
                clip: true

                boundsBehavior: Flickable.StopAtBounds
                // New in Qt 6.5: no need to do it by hand!!
                resizableColumns: true

                delegate: RowLayout {
                    spacing: 0

                    Button {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        // TODO workaround: not sure why this doesn't work
                        // with just the binding, when using Button?
                        // Maybe bug to be raised to Qt?
                        text: tableView.model.headerData(index, Qt.Horizontal, Qt.DisplayRole)
                        onClicked: {
                            // TODO would be nice to draw the litle arrows to show
                            // which column is being sorted.
                            let order = Qt.AscendingOrder;

                            if (sortModel.sortColumn == index) {
                                order = sortModel.sortOrder

                                if (order == Qt.AscendingOrder)
                                    order = Qt.DescendingOrder
                                else
                                    order = Qt.AscendingOrder
                            }

                            sortModel.sort(index, order)
                        }
                    }
                    Rectangle {
                        Layout.preferredWidth: 5
                        Layout.fillHeight: true

                        color: "darkgray"
                    }
                }
            }

            TableView {
                property real rowCellHeight: 30

                id: tableView
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                flickDeceleration: 10000

                boundsBehavior: Flickable.StopAtBounds

                ScrollBar.horizontal: ScrollBar {
                    //policy: ScrollBar.AlwaysOn
                }
                ScrollBar.vertical: ScrollBar {
                    //policy: ScrollBar.AlwaysOn
                }

                delegate: NiceLabel {
                    text: display
                    horizontalAlignment: column == 3 ? Qt.AlignRight : Qt.AlignLeft

//                        background: Rectangle {
//                            visible: isSelected
//                            color: "lightblue"
//                        }
                }

                // Bug in Qt 6.5
                //resizableColumns: true
                onLayoutChanged: {
                    // Can save explicitColumnWidth() output to remember column sizes
                    //console.log("layout")
                }
                columnWidthProvider: (column) => {
                    // Set through setColumnWidths() or resizable column
                    // return 0 = hide column
                    let w = explicitColumnWidth(column)
                    if (w >= 0)
                        return Math.max(80, w);
                    else
                        // implicit delegate size. Clamp to 80 minimum
                        return Math.max(80, implicitColumnWidth(column))
                }

                rowHeightProvider: (row) => {
                    return rowCellHeight;
                }

                model: SortModel {
                    id: sortModel
                    model: contentsModel
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onDoubleClicked: (mouse) => {
                        var cell = tableView.cellAtPosition(mouse.x, mouse.y, true)

                        if (cell.x != -1 && cell.y != -1) {
                            contentsModel.cellDoubleClicked(cell)
                        }
                    }

                    onPositionChanged: (mouse) => {
                        var cell = tableView.cellAtPosition(mouse.x, mouse.y, true)
                        //console.log(mouse.x, mouse.y, cell)

                        if (cell.x != -1 && cell.y != -1) {
                            if (!highlightRect.visible) {
                                highlightRect.visible = true;
                            }

                            highlightRect.y = cell.y * tableView.rowCellHeight;
                        }
                        else {
                            highlightRect.visible = false;
                        }
                    }
                }

                Rectangle {
                    id: highlightRect
                    color: "lightblue"
                    width: parent.width
                    height: tableView.rowCellHeight
                    visible: false

                    Connections {
                        target: contentsModel

                        function onModelReset() {
                            highlightRect.visible = false
                        }
                    }
                }
            }
        }
    }
}
