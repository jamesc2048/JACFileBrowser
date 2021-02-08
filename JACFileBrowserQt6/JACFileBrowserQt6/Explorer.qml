import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

import QtQuick.Controls.Universal

SplitView {
    id: splitView
    focus: true

    property int cellSize: 100

    signal imageViewRequested(url imageUrl)

    ListView {
        id: driveList
        SplitView.minimumWidth: 100
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar{}

        model: 50

        delegate: Label {
            text: modelData
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true

            onClicked: {
                driveList.focus = true
                mouse.accepted = false
            }
        }
    }

    GridView {
        id: grid

        SplitView.fillWidth: true

        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar{}

        cellWidth: cellSize
        cellHeight: cellSize

        model: ViewModel.contentModel

        delegate: Rectangle {
            width: cellSize
            height: cellSize

            // TODO query style?
            color: isSelected ? "lightblue" : (Universal.theme == Universal.Dark ? "#333" : "white")

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                id: mouseArea

                onClicked: {
                    ViewModel.contentModel.toggleSelect(index)
                }
                onDoubleClicked: {
                    console.log("double click " + index)

                    if (isImage) {
                        imageViewRequested(url)
                    }
                    else {
                        ViewModel.contentModel.itemDoubleClicked(index)
                    }
                }
            }

            ToolTip {
                delay: 300
                text: name
                visible: mouseArea.containsMouse
            }

            ColumnLayout {
                width: cellSize
                height: cellSize

                Image {
                    Layout.fillHeight: true
                    Layout.maximumWidth: cellSize

                    source: {
                        if (isDir) {
                            return "qrc:///resources/folder.png"
                        }
                        else if (isImage) {
                            return url
                        }
                        else {
                            return "qrc:///resources/file.png"
                        }
                    }

                    sourceSize.width: cellSize
                    sourceSize.height: 0
                    asynchronous: true
                    cache: false
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    Layout.preferredHeight: 20
                    Layout.maximumWidth: cellSize
                    Layout.alignment: Qt.AlignHCenter

                    text: name
                    elide: Text.ElideRight
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true

            onClicked: {
                grid.focus = true
                mouse.accepted = false
            }
        }

        Keys.onPressed: {
            switch (event.key) {
                default:
                    console.log("Key handle grid", event.key)
            }
        }
    }
}
