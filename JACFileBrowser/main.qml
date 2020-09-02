import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: qsTr("JACFileExplorer")

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")

            Action {
                text: "New Tab"
                shortcut: "Ctrl+T"
                onTriggered: backend.newTab(tabBar.currentIndex)
            }

            Action {
                text: "Close Tab"
                shortcut: "Ctrl+W"
                onTriggered: {
                    backend.closeTab(tabBar.currentIndex)

                    if (backend.tabsModel.rowCount() <= 0) {
                        Qt.quit();
                    }
                }
            }

            MenuSeparator { }

            Action {
                text: "Quit"
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }
    }

    ColumnLayout {
        id: mainLayout

        anchors.fill: parent

        TabBar {
            id: tabBar
            Layout.fillWidth: true

            Repeater {
                model: backend.tabsModel

                delegate: TabButton {
                    text: path
                }
            }
        }

        StackLayout {
            currentIndex: tabBar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: backend.tabsModel

                delegate: ListView {
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollBar.vertical: ScrollBar {}

                    model: contentsModel

                    delegate: Text {
                        text: modelData
                    }
                }
            }
        }
    }
}
