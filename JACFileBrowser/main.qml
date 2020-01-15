import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "JAC File Browser"

    ColumnLayout {
        anchors.fill: parent

        TabBar {
            Layout.fillWidth: true

            id: tabBar

            Repeater {
                model: viewModel.explorerTabs

                delegate: TabButton {
                    text: "Tab " + (index + 1) + " - " + name
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
