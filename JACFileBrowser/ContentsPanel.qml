import QtCore
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Universal

import Qt.labs.platform as Labs
import Qt.labs.qmlmodels

import JACFileBrowser

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        HorizontalHeaderView {
            id: headerView
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

            component NiceSelectionRectangle : Rectangle {
                color: "lightblue"
                opacity: 0.7
            }

            delegate: DelegateChooser {
                DelegateChoice {
                    column: 0

                    Item {
                        // Have to forward this to make the table column automatic sizing work
                        // adding offset for icon and padding
                        // TODO should not be hard coded value
                        implicitWidth: delegateLabel.implicitWidth + 35

                        RowLayout {
                            anchors.fill: parent

                            // TODO this needs optimisation
                            // E.G. on network paths it's slow
                            // Maybe cache the icon once the extension has been seen?
                            QMLIconPainter {
                                visible: settings.showIcons
                                Layout.leftMargin: 5
                                Layout.fillHeight: true
                                Layout.preferredWidth: 22
                                path: absolutePath
                            }

                            NiceLabel {
                                id: delegateLabel
                                text: display
                                horizontalAlignment: Qt.AlignLeft
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                            }
                        }

                        NiceSelectionRectangle {
                            visible: isSelected
                            anchors.fill: parent
                        }
                    }
                }

                DelegateChoice {
                    NiceLabel {
                        text: display
                        horizontalAlignment: column == 3 ? Qt.AlignRight : Qt.AlignLeft

                        background:  NiceSelectionRectangle {
                            visible: isSelected
                        }
                    }
                }
            }
            // Bug in Qt 6.5
            //resizableColumns: true
            onLayoutChanged: {
                // Can save explicitColumnWidth() output to remember column sizes
                //console.log("layout")
            }
            columnWidthProvider: (column) => {
                const minColumnSize = 100;

                // Set through setColumnWidths() or resizable column
                // return 0 = hide column
                let w = explicitColumnWidth(column)
                if (w >= 0)
                    return Math.max(minColumnSize, w);
                else
                    // implicit delegate size. Clamp to a minimum
                    return Math.max(minColumnSize, implicitColumnWidth(column))
            }

            rowHeightProvider: (row) => {
                return rowCellHeight;
            }

            model: sortModel

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
                        //var i = sortModel.index(cell.y, cell.x)
                        //var sourceCell = sortModel.mapToSource(i)

                        //console.log(`Selecting at index ${i}`)

                        sortModel.select(cell, container.isCtrlPressed, container.isShiftPressed);
                        //var isSelected = contentsModel.data(sourceCell, Qt.UserRole + 5)
                        //contentsModel.setData(sourceCell, !isSelected, Qt.UserRole + 5)

                        //console.log(`Row was ${isSelected ? "de" : ""}selected`)
                    }
                }

                onDoubleClicked: (mouse) => {
                    var cell = tableView.cellAtPosition(mouse.x, mouse.y, true)

                    if (cell.x != -1 && cell.y != -1) {
                        var i = sortModel.index(cell.y, cell.x)
                        var sourceCell = sortModel.mapToSource(i)

                        console.log(contentsModel.data(sourceCell, Qt.UserRole + 1))

                        var comp = Qt.createComponent("PreviewDialog.qml", null);
                        var item = comp.createObject(window, { "name": "testssss" })
                        item.open()
                        //contentsModel.cellDoubleClicked(Qt.point(sourceCell.column, sourceCell.row))
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

                function onModelReset() {
                    // Scroll tableview to top when model reset
                    tableView.contentY = 0
                }
            }
        }
    }

    NiceLabel {
        text: "This folder is empty."
        y: headerView.height + 5
        width: parent.width
        horizontalAlignment: Qt.AlignHCenter
        visible: contentsModel.rows === 0 && !contentsModel.isLoading
    }

    NiceLabel {
        text: "Loading..."
        y: headerView.height + 5
        width: parent.width
        horizontalAlignment: Qt.AlignHCenter
        visible: contentsModel.isLoading
    }
}
