import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.qmlmodels

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: "JAC File Browser"

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: "🡐"
            }
            ToolButton {
                text: "🡒"
            }
            ToolButton {
                text: "🡑"
            }

            TextField {
                text: "C:\\"
                Layout.fillWidth: true
            }

            ToolButton {
               text: "Go"
            }
        }
    }

    SplitView {
        anchors.fill: parent



        ListView {
            SplitView.preferredWidth: 300
            SplitView.fillHeight: true
            clip: true
            delegate: Label { text: display }

            boundsBehavior: Flickable.StopAtBounds
            model: testListModel

            ScrollBar.vertical: ScrollBar {
                //policy: ScrollBar.AlwaysOn
            }
        }

        ColumnLayout {
            SplitView.fillWidth: true
            SplitView.fillHeight: true

            HorizontalHeaderView {
                syncView: tableView
                clip: true
                Layout.fillWidth: true

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
                        onClicked: console.log("TODO sorting", index)
                    }
                    Rectangle {
                        Layout.preferredWidth: 5
                        Layout.fillHeight: true

                        //color: ma.containsMouse ? "darkgray" : "gray"
                        color: "darkgray"

                        // Could be useful to make drag target bigger without
                        // making it visually bigger.
                        // This is used in SplitView handle
                        //containmentMask: Item {
                        //     x: (handleDelegate.width - width) / 2
                        //     width: 64
                        //     height: splitView.height
                        // }

//                        MouseArea {
//                            id: ma
//                            hoverEnabled: true
//                            anchors.fill: parent
//                            onHoveredChanged: console.log("header hover", index, containsMouse)
//                            onPressed: console.log("header click", index, mouse.x)
//                            onReleased: console.log("header release", index, mouse.x)
//                            onPositionChanged: {
//                                // TODO could use to make columns draggable?
//                                // IDEA: use index to index into array of column widths.
//                                // as you end the drag we update the width and
//                                // call forceLayout() on the tableView
//                            //    if (pressed) console.log("header move", index, mouse.x)
//                            }
//                            //preventStealing: true
//                            propagateComposedEvents: true
//                        }
                    }
                }
            }

            TableView {
                Component.onCompleted: {
//                    setTimeout(2000, () => {
//                        tableView.resizableColumns = true;
//                        tableView.forceLayout();
//                    })
                }

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
                }

                // Bug in Qt 6.5
                //resizableColumns: true
                onLayoutChanged: {
                    // Can save explicitColumnWidth() output to remember column sizes
                    console.log("layout")
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

                model: testTableModel
            }
        }
    }
}
