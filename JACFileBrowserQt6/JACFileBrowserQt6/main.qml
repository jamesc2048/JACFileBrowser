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
                 onTriggered: explorer.cellSize *= 1.25;
             }
             Action {
                 text: "Decrease Grid Size"
                 onTriggered: explorer.cellSize /= 1.25;
             }
         }
     }

    ColumnLayout {
        anchors.fill: parent

        ToolBar {
            id: toolBar

            Layout.fillWidth: true

            // only visible on initial stack
            visible: stackView.depth == 1

             RowLayout {
                 id: toolRow
                 anchors.fill: parent

                 ToolButton {
                     text: "←"
                     // TODO implement history
                     //onClicked: stack.pop()
                 }

                 ToolButton {
                     text: "→"
                     // TODO implement history
                     //onClicked: stack.pop()
                 }

                 ToolButton {
                     text: "↑"

                     onClicked: ViewModel.contentModel.path = ViewModel.contentModel.path + "/.."
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
             }
         }

        StackView {
            id: stackView

            Layout.fillWidth: true
            Layout.fillHeight: true

            initialItem: Explorer {
                id: explorer

                onImageViewRequested: {
                    stackView.push("ImageViewer.qml", {
                        "imageUrl": imageUrl,
                        "stackView": stackView
                    })
                }
            }

        }
    }

    footer: Item {

    }
}
