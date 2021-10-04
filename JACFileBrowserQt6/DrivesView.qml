import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ListView {
   id: listView
   SplitView.preferredWidth: 150
   SplitView.fillHeight: true

   boundsBehavior: Flickable.StopAtBounds

   model: drivesModel

   leftMargin: 5
   spacing: 5

   delegate: Label {
       width: parent.width
       text: display
   }

   ScrollBar.vertical: ScrollBar{}

   MouseArea {
       anchors.fill: parent
       propagateComposedEvents: true

       onDoubleClicked: {
           // Add contentX/Y to make it work when scrolled
           const clicked = listView.indexAt(mouse.x + listView.contentX,
                                            mouse.y + listView.contentY)
           console.log("clicked listview cell", clicked)

           if (clicked == -1) {
                return;
           }

           // perform navigation
           const drive = drivesModel.data(drivesModel.index(clicked, 0), Qt.DisplayRole);
           console.log("navigating to drive", drive)

           contentsModel.loadDirectory(drive);
       }

       onPressed: {
           keyFocus.forceActiveFocus()
           console.log("forceActiveFocus")
       }

    }
}
