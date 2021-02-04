import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: "JACFileBrowserQt6"

    Component.onCompleted: {
//        Utils.httpGet("https://www.httpvshttps.com/", function(result) {
//            console.log(result)
//        })

        ViewModel.contentModel.path = "D:\\"
        //ViewModel.contentModel.path = "E:\\QuickVideoRecorder\\swimming pool\\frames\\V_20200806_152438_ES0"
    }

    menuBar: MenuBar {
         Menu {
             title: qsTr("&View")

             Action {
                 text: "Increase Grid Size"
                 onTriggered: grid.cellSize *= 1.25;
             }
             Action {
                 text: "Decrease Grid Size"
                 onTriggered: grid.cellSize /= 1.25;
             }
         }
     }

    header: ToolBar {
         RowLayout {
             anchors.fill: parent
             ToolButton {
                 text: qsTr("<")
                 onClicked: stack.pop()
             }
             ToolButton {
                 text: qsTr(">")
                 onClicked: stack.pop()
             }
             TextField {
                 text: ViewModel.contentModel.path
                 horizontalAlignment: Qt.AlignHCenter
                 verticalAlignment: Qt.AlignVCenter
                 Layout.fillWidth: true
                 selectByMouse: true

                 Keys.onPressed: {
                     if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
                        ViewModel.contentModel.path = text
                     }
                 }
             }
             ToolButton {
                 text: qsTr("⋮")
                 onClicked: menu.open()
             }
         }
     }

    SplitView {
        anchors.fill: parent

        ListView {
            SplitView.minimumWidth: 100
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar{}

            model: 50

            delegate: Text {
                text: modelData
            }
        }

        GridView {
            id: grid

            SplitView.fillWidth: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar{}

            property int cellSize: 100
            cellWidth: cellSize
            cellHeight: cellSize

            model: ViewModel.contentModel

            delegate: Rectangle {
                width: grid.cellWidth
                height: grid.cellHeight

                color: isSelected ? "lightblue" : "white"

                MouseArea {
                    anchors.fill: parent

                    onClicked: isSelected = !isSelected
                    onDoubleClicked: {
                        console.log("double click " + index)
                        ViewModel.contentModel.itemDoubleClicked(index)
                    }
                }

                ColumnLayout {
                    width: grid.cellWidth
                    height: grid.cellHeight

                    Image {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        source: url
                        sourceSize.width: grid.cellWidth
                        sourceSize.height: 0
                        asynchronous: true
                        cache: false
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        Layout.preferredHeight: 20
                        Layout.fillWidth: true

                        text: name
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    footer: Item {

    }
}
