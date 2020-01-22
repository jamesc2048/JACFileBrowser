import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12

ScrollView {
    property int vmIndex

    clip: true

    ListView {
        id: listView
        Layout.preferredHeight: contentHeight
        Layout.fillWidth: true

        model: currentContents

//        highlight: Rectangle {
//            color: "lightsteelblue";
//            radius: 5
//            width: parent.width
//        }

        //highlightFollowsCurrentItem: true

        delegate: Rectangle {
            property bool isSelected: false

            id: rect
            width: parent.width
            height: 20
            color: isSelected ? "#FFCCCCCC" : "transparent"

            Text {
                id: text
                width: parent.width
                height: 20
                text: (isDir ? "Dir: " : "File: ") + name + (rect.isSelected ? "(selected)" : "")

                MouseArea {
                    acceptedButtons: Qt.AllButtons
                    anchors.fill: parent
                    onClicked: {
                        if (mouse.button == Qt.LeftButton) {
                            console.log("Left mouse")
                            rect.isSelected = !rect.isSelected
                        }
                        else if (mouse.button == Qt.RightButton) {
                            console.log("Right mouse")
                            menu.open()
                        }
                    }

                    onDoubleClicked: viewModel.explorerTabs.get(vmIndex).contentDoubleClick(index)

                    Menu {
                        id: menu
                        title: ("&Edit")

                        Action { text: "Cu&t" }
                        Action { text: "&Copy" }
                        Action { text: "&Paste" }
                    }
                }
            }
        }
    }
}
