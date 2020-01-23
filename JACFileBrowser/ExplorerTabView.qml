import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12

ScrollView {
    property int vmIndex

    clip: true

    StackLayout {
        Layout.preferredHeight: contentHeight
        Layout.fillWidth: true
        currentIndex: isRefreshing ? 0 : 1

        Text {
            renderType: Text.NativeRendering
            text: "Refreshing..."
        }

        ListView {

            id: listView
            Layout.preferredHeight: contentHeight
            Layout.fillWidth: true
            focus: true

            model: currentContents

            property bool ctrlPressed: false

            Keys.onPressed: {
                if (event.modifiers == Qt.ControlModifier) {
                    ctrlPressed = true
                }
            }

            Keys.onReleased:  {
                if (event.modifiers == Qt.ControlModifier) {
                    ctrlPressed = false
                }
            }

            delegate: Rectangle {
                id: rect
                width: parent.width
                height: 25
                color: isSelected ? "#FFCCCCCC" : "transparent"

                Text {
                    renderType: Text.NativeRendering
                    id: text
                    anchors.fill: parent
                    text: (isDir ? "Dir: " : "File: ") + name + (isSelected ? "(selected)" : "")

                    Menu {
                        id: menu
                        title: ("&Edit")

                        Action { text: "Cu&t" }
                        Action { text: "&Copy" }
                        Action { text: "&Paste" }
                    }

                    MouseArea {
                        propagateComposedEvents: true
                        acceptedButtons: Qt.AllButtons
                        anchors.fill: parent
                        onContainsMouseChanged: console.log("mouseee")
                        onClicked: {
                            console.log("mousebutton " + mouse.button)

                            if (mouse.button == Qt.LeftButton && viewModel.isCtrlPressed) {
                                console.log("Left mouse with ctrl")
                                isSelected = !isSelected
                            }
                            else if (mouse.button == Qt.RightButton) {
                                console.log("Right mouse")
                                menu.open()
                            }
                        }

                        onDoubleClicked: {
                            console.log("doubleclicked")
                            viewModel.explorerTabs.get(vmIndex).contentDoubleClick(index)
                        }


                    }
                }
            }
        }
    }
}
