import QtCore
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform as Labs
import QtQuick.Controls.Universal

import JACFileBrowser

ListView {
    id: listView
    clip: true
    flickDeceleration: 10000

    delegate: NiceLabel {
        width: parent.width
        text: display
        height: 30
    }

    boundsBehavior: Flickable.StopAtBounds
    model: drivesModel

    ScrollBar.vertical: ScrollBar {
        //policy: ScrollBar.AlwaysOn
    }

    NiceLabel {
        width: parent.width
        horizontalAlignment: Qt.AlignHCenter
        text: "Loading..."
        visible: drivesModel.rows == 0
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onContainsMouseChanged: {
            if (!containsMouse) {
                listHighlightRect.visible = false;
            }
        }

        onPositionChanged: (mouse) => {
            var cell = listView.indexAt(mouse.x, mouse.y)

           if (cell != -1) {
               if (!listHighlightRect.visible) {
                   listHighlightRect.visible = true;
               }

               listHighlightRect.y = cell * listHighlightRect.rowHeight;
           }
            else {
                listHighlightRect.visible = false;
            }
        }

        onDoubleClicked: (mouse) => {
            var cell = listView.indexAt(mouse.x, mouse.y)

            if (cell != -1) {
                // TODO make the enums nicer here
                let dir = drivesModel.data(drivesModel.index(cell, 0), Qt.UserRole + 1)
                contentsModel.currentDir = dir;
            }
        }
    }

    HighlightRectangle {
        id: listHighlightRect
    }
}
