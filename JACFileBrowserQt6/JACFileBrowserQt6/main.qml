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

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: Explorer {
            id: explorer

            onImageViewRequested: {
                stackView.push("ImageViewer.qml", { "image": image })
            }
        }

    }

    footer: Item {

    }
}
