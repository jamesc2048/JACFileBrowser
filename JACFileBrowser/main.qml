import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "JAC File Browser"

    menuBar: MenuBar {
        Menu {
            title: "&File"

            Action {
                text: qsTr("&Quit")
                onTriggered: Qt.quit()
            }
        }

        Menu {
            title: ("&Edit")

            Action { text: qsTr("Cu&t") }
            Action { text: qsTr("&Copy") }
            Action { text: qsTr("&Paste") }
        }

        Menu {
            title: ("&Help")

            Action { text: ("&About") }
        }

    }

    ColumnLayout {
        anchors.fill: parent
        focus: true

        Keys.onPressed: {
            console.log(event.key)
            console.log(event.modifiers)

            // Ctrl key id
            if (event.key == 16777249) {
                viewModel.isCtrlPressed = true
            }

            if (viewModel.isCtrlPressed) {
                if (event.key == Qt.Key_T) {
                    viewModel.openNewTab()
                    event.accepted = true
                }
                else if (event.key == Qt.Key_W) {
                    viewModel.closeCurrentTab()
                    event.accepted = true
                }
            }
        }

        Keys.onReleased: {
            console.log(event.key)
            console.log(event.modifiers)

            if (event.key == 16777249) {
                viewModel.isCtrlPressed = false
            }
        }

        TabBar {
            visible: viewModel.explorerTabs.count > 1
            Layout.fillWidth: true

            id: tabBar

            onCurrentIndexChanged: viewModel.currentTabIndex = tabBar.currentIndex

            Repeater {
                model: viewModel.explorerTabs

                delegate: TabButton {
                    text: name
                }
            }

        }

        StackLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            currentIndex: tabBar.currentIndex

            Repeater {
                model: viewModel.explorerTabs

                delegate: ExplorerTabView {
                    vmIndex: index
                }
            }

            MouseArea {
                acceptedButtons: Qt.AllButtons
                Layout.fillHeight: true
                Layout.fillWidth: true

                onPressed: console.log("aaaaa")
            }
        }
    }
}
