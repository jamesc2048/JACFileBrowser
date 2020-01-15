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

        highlight: Rectangle {
            color: "lightsteelblue";
            radius: 5
            width: parent.width
        }

        highlightFollowsCurrentItem: true

        delegate: Text {
            id: t
            width: parent.width
            height: 20
            text: (isDir ? "Dir: " : "File: ") + name

            MouseArea {
                anchors.fill: parent
                onClicked: listView.currentIndex = index
                onDoubleClicked: viewModel.explorerTabs.get(vmIndex).contentDoubleClick(index)
            }
        }


    }
}
