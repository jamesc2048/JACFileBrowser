import QtCore
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform as Labs
import QtQuick.Controls.Universal

import JACFileBrowser

ColumnLayout {
    property int rowHeight: 30

    ListModel {
        id: standardLocationsModel

        Component.onCompleted: {
            const pathsToLoad = [
                StandardPaths.HomeLocation,
                StandardPaths.DesktopLocation,
                StandardPaths.DocumentsLocation,
                StandardPaths.DownloadLocation,
                StandardPaths.MusicLocation,
                StandardPaths.PicturesLocation,
                StandardPaths.MoviesLocation,
            ]

            for (let sp of pathsToLoad) {
                let name = StandardPaths.displayName(sp)

                for (let sl of StandardPaths.standardLocations(sp)) {
                    append({ "name": name, "pathUrl": sl.toString().substr(8) })
                }
            }
        }
    }

    DrivesModel {
        id: drivesModel
    }

    NiceLabel {
        Layout.alignment: Qt.AlignHCenter
        text: "Folders"
    }

    ListView {
        id: standardLocationsView
        Layout.fillWidth: true
        Layout.preferredHeight: contentHeight

        model: standardLocationsModel

        delegate: NiceLabel {
            width: parent.width
            text: `${name} (${utilities.toNativeSeparators(pathUrl)})`
            height: rowHeight
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onContainsMouseChanged: {
                if (!containsMouse) {
                    shortcutsHighlightRect.visible = false;
                }
            }

            onPositionChanged: (mouse) => {
                var cell = standardLocationsView.indexAt(mouse.x, mouse.y)

               if (cell != -1) {
                   if (!shortcutsHighlightRect.visible) {
                       shortcutsHighlightRect.visible = true;
                   }

                   shortcutsHighlightRect.y = cell * shortcutsHighlightRect.rowHeight;
               }
                else {
                    shortcutsHighlightRect.visible = false;
                }
            }

            onDoubleClicked: (mouse) => {
                var cell = standardLocationsView.indexAt(mouse.x, mouse.y)

                if (cell != -1) {
                    let pathUrl = standardLocationsModel.get(cell).pathUrl

                    console.log("Loading special dir", pathUrl)
                    activeContentsPanel.contentsModel.currentDir = pathUrl;
                }
            }
        }

        HighlightRectangle {
            id: shortcutsHighlightRect
        }
    }

    NiceLabel {
        Layout.alignment: Qt.AlignHCenter
        text: "Drives"
    }

    ListView {
        id: drivesView
        Layout.fillWidth: true
        // allow label to show when loading
        Layout.preferredHeight: drivesModel.rows == 0 ? 30 : contentHeight

        clip: true
        flickDeceleration: 10000

        delegate: NiceLabel {
            width: parent.width
            text: display
            height: rowHeight
        }

        boundsBehavior: Flickable.StopAtBounds
        model: drivesModel

        ScrollBar.vertical: ScrollBar {
            //policy: ScrollBar.AlwaysOn
        }

        NiceLabel {
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
                var cell = drivesView.indexAt(mouse.x, mouse.y)

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
                var cell = drivesView.indexAt(mouse.x, mouse.y)

                if (cell != -1) {
                    // TODO make the enums nicer here
                    let dir = drivesModel.data(drivesModel.index(cell, 0), Qt.UserRole + 1)
                    activeContentsPanel.contentsModel.currentDir = dir;
                }
            }
        }

        HighlightRectangle {
            id: listHighlightRect
        }
    }

    // This is stupid but can't get ColumnLayout to stop
    // aligning vertical middle....
    Item {
        Layout.fillHeight: true
    }
}
