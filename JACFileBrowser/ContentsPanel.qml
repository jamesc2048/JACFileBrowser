import QtCore
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform as Labs
import QtQuick.Controls.Universal

import JACFileBrowser

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

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

                        if (sortModel.sortColumn() == index) {
                            order = sortModel.sortOrder()

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
                text: `${column == 0 && !isFile ? '📁' : ''}${display}`
                horizontalAlignment: column == 3 ? Qt.AlignRight : Qt.AlignLeft

                background: Rectangle {
                    visible: isSelected
                    color: "lightblue"
                }
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

                onContainsMouseChanged: {
                    if (!containsMouse) {
                        tableHighlightRect.visible = false;
                    }
                }

                onClicked: (mouse) => {
                    var cell = tableView.cellAtPosition(mouse.x, mouse.y, true)

                    if (cell.x != -1 && cell.y != -1) {
                        var i = sortModel.index(cell.y, cell.x)
                        var sourceCell = sortModel.mapToSource(i)

                        // TODO need constants in QML
                        var isSelected = contentsModel.data(sourceCell, Qt.UserRole + 5)
                        contentsModel.setData(sourceCell, !isSelected, Qt.UserRole + 5)
                    }
                }

                onDoubleClicked: (mouse) => {
                    var cell = tableView.cellAtPosition(mouse.x, mouse.y, true)

                    if (cell.x != -1 && cell.y != -1) {
                        var i = sortModel.index(cell.y, cell.x)
                        var sourceCell = sortModel.mapToSource(i)

                        contentsModel.cellDoubleClicked(Qt.point(sourceCell.column, sourceCell.row))
                    }
                }

                onPositionChanged: (mouse) => {
                    var cell = tableView.cellAtPosition(mouse.x, mouse.y, true)

                    if (cell.x != -1 && cell.y != -1) {
                        if (!tableHighlightRect.visible) {
                            tableHighlightRect.visible = true;
                        }

                        tableHighlightRect.y = cell.y * tableView.rowCellHeight;
                    }
                    else {
                        tableHighlightRect.visible = false;
                    }
                }
            }

            HighlightRectangle {
                id: tableHighlightRect
            }

            Connections {
                target: contentsModel
                onModelReset: tableView.contentY = 0
            }
        }
    }
}
