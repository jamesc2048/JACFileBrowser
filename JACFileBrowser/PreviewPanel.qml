import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: previewRoot

    SplitView.preferredWidth: 300
    SplitView.fillHeight: true

    Component {
        id: imageComponent

        Image {
            source: contentsModel.lastSelectedUrl
            autoTransform: true
            fillMode: Image.PreserveAspectFit
            asynchronous: true
        }
    }

    function isImageFile(path) {
        // Crude extension-based recognition
        let pathStr = path.toString();
        let isImage = /\.(?:jpe?g|png)$/i.test(pathStr);
        console.log("Preview: testing for image heuristic", pathStr, isImage)
        return isImage
    }

    ColumnLayout {
        anchors.fill: parent

        NiceLabel {
            text: contentsModel.lastSelectedUrl !== Qt.url("") ?
                      "Selected: " + contentsModel.lastSelectedUrl.toString() :
                      "No selection"
        }

        Loader {
            Layout.fillHeight: true
            Layout.fillWidth: true
            asynchronous: true
            sourceComponent: previewRoot.visible && isImageFile(contentsModel.lastSelectedUrl) ?
                                 imageComponent : null
        }
    }
}
