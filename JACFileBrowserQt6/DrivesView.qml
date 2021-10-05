import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    SplitView.preferredWidth: 150
    SplitView.minimumWidth: 50
    SplitView.fillHeight: true

    Label {
        text: "This PC"
        Layout.leftMargin: 5
    }

    ListView {
       id: listView
       Layout.fillWidth: true
       Layout.fillHeight: true

       boundsBehavior: Flickable.StopAtBounds

       model: drivesModel

       leftMargin: 15
       spacing: 5

       delegate: Label {
           width: parent.width
           text: isSpecialFolder ? name : `${name} (${fullPath})`
       }

       MouseArea {
           anchors.fill: parent
           propagateComposedEvents: true

           hoverEnabled: true

           onDoubleClicked: {
               // Add contentX/Y to make it work when scrolled
               const clicked = listView.indexAt(mouse.x + listView.contentX,
                                                mouse.y + listView.contentY)
               console.log("clicked listview cell", clicked)

               if (clicked == -1) {
                    return;
               }

               // perform navigation
               const drive = drivesModel.data(drivesModel.index(clicked, 0), Qt.UserRole + 2);
               console.log("navigating to drive", drive)

               contentsModel.loadDirectory(drive);
           }

           onPressed: {
               keyFocus.forceActiveFocus()
               console.log("forceActiveFocus")
           }

           onPositionChanged: {
               const pos = listView.indexAt(mouse.x, mouse.y);

               highlightRect.rowPosition = pos
           }

           onExited: highlightRect.rowPosition = -1
        }


       Rectangle {
           property int rowPosition: -1
           property int rowHeight: 25

           id: highlightRect
           color: "lightblue"

           visible: rowPosition >= 0
           enabled: rowPosition >= 0

           width: parent.width
           height: rowHeight

           y: rowHeight * rowPosition
           opacity: 0.4
       }
    }
}
