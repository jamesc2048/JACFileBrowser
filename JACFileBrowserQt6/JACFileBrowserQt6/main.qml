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
        Utils.httpGet("https://www.httpvshttps.com/", function(result) {
            console.log(result)
        })
    }

    menuBar: MenuBar {
         Menu {
             title: qsTr("&File")
             Action { text: qsTr("&New...") }
             Action { text: qsTr("&Open...") }
             Action { text: qsTr("&Save") }
             Action { text: qsTr("Save &As...") }
             MenuSeparator { }
             Action { text: qsTr("&Quit") }
         }
         Menu {
             title: qsTr("&Edit")
             Action { text: qsTr("Cu&t") }
             Action { text: qsTr("&Copy") }
             Action { text: qsTr("&Paste") }
         }
         Menu {
             title: qsTr("&Help")
             Action { text: qsTr("&About") }
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
                 text: "path"
                 horizontalAlignment: Qt.AlignHCenter
                 verticalAlignment: Qt.AlignVCenter
                 Layout.fillWidth: true
                 selectByMouse: true

                 Keys.onEnterPressed: {
                     // load path
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

        Text {
            SplitView.minimumWidth: 100
            text: "drives"
        }

        Text {
            SplitView.fillWidth: true
            text: "contents"
        }
    }

    footer: Item {

    }
}
