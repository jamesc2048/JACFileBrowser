import JACFileBrowser
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

ApplicationWindow {
    id: window
    width: 1024
    height: 768
    visible: true
    title: "JAC File Browser"

    Utilities {
        id: utilities
    }

    ContentsModel{
        id: contentsModel
        currentDir: "C:\\SDK\\Qt"
    } /*TestTableModel {
        rows: 100
        columns: 20

        property string currentDir: "D:\\"
        onCurrentDirChanged: console.log("onCurrentDirChanged", currentDir)

        function undo() {
            console.log("undo");
        }

        function redo() {
            console.log("redo");
        }

        function parentDir() {
            console.log("parentDir");
        }

        function sortByColumn(index) {
            console.log("sortByColumn", index);
        }
    }*/

    TestListModel {
        id: listModel
        rows: 100
    }

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

    header: ToolBar {
        RowLayout {
            anchors.fill: parent

            ToolButton {
                text: "🡐"
                onClicked: contentsModel.undo()
            }
            ToolButton {
                text: "🡒"
                onClicked: contentsModel.redo()
            }
            ToolButton {
                text: "🡑"
                onClicked: contentsModel.parentDir()
            }

            TextField {
                id: currentDirTextField
                Layout.fillWidth: true
                text: contentsModel.currentDir
                onAccepted: contentsModel.currentDir = text
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
            delegate: Label {
                text: display
                clip: true
                elide: Text.ElideRight
                padding: 5
            }

            boundsBehavior: Flickable.StopAtBounds
            model: listModel

            ScrollBar.vertical: ScrollBar {
                //policy: ScrollBar.AlwaysOn
            }
        }

        ColumnLayout {
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
                        onClicked: contentsModel.sortByColumn(index)
                    }
                    Rectangle {
                        Layout.preferredWidth: 5
                        Layout.fillHeight: true

                        color: "darkgray"
                    }
                }
            }

            TableView {
                function setTimeout(delayTime, cb) {
                    return _timer(delayTime, cb, false)
                }

                function setInterval(delayTime, cb) {
                    return _timer(delayTime, cb, true)
                }

                function _timer(delayTime, cb, isInterval) {
                    var timer = Qt.createQmlObject("import QtQuick 2.0; Timer {}", root);
                    timer.interval = delayTime;
                    timer.repeat = isInterval;
                    timer.triggered.connect(cb);
                    timer.start();
                }

                property list<string> columnWidths

                id: tableView
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true

                boundsBehavior: Flickable.StopAtBounds

                ScrollBar.horizontal: ScrollBar {
                    //policy: ScrollBar.AlwaysOn
                }
                ScrollBar.vertical: ScrollBar {
                    //policy: ScrollBar.AlwaysOn
                }

                delegate: Label {
                    text: display
                    clip: true
                    elide: Text.ElideRight
                    padding: 5

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
                    return 30;
                }

                model: contentsModel

                MouseArea {
                    anchors.fill: parent

                    onDoubleClicked: (mouse) => {
                        var cell = tableView.cellAtPosition(mouse.x, mouse.y, true)
                        console.log(mouse.x, mouse.y, cell)

                        if (cell.x != -1 && cell.y != -1) {
                            contentsModel.cellDoubleClicked(cell)
                        }
                    }
                }
            }
        }
    }
}
