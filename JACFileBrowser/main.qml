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

        TabBar {
            Layout.fillWidth: true

            id: tabBar

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
        }
    }
}
