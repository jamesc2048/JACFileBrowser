import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Universal

Item {
    id: previewRoot

    property string textPreview

    Component {
        id: imageComponent

        Image {
            source: activeContentsPanel.contentsModel.lastSelectedUrl
            autoTransform: true
            fillMode: Image.PreserveAspectFit
            asynchronous: true
        }
    }

    Component {
        id: textComponent

        Flickable {
            id: textPreviewFlickable
            flickDeceleration: 10000
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            contentWidth: textPreviewLabel.width
            contentHeight: textPreviewLabel.height

            ScrollBar.horizontal: ScrollBar {
                //policy: ScrollBar.AlwaysOn
            }
            ScrollBar.vertical: ScrollBar {
                //policy: ScrollBar.AlwaysOn
            }


            TextEdit {
                id: textPreviewLabel
                text: previewRoot.textPreview
                selectByMouse: true
                selectByKeyboard: true
                // TODO this isn't very clean
                color: Universal.theme == Universal.Dark ? "white" : "black"
            }
//            NiceLabel {
//                id: textPreviewLabel
//                text: previewRoot.textPreview
//            }

            Connections {
                target: previewRoot

                function onTextPreviewChanged() {
                    textPreviewFlickable.contentX = 0
                    textPreviewFlickable.contentY = 0
                }
            }
        }
    }

    function isImageFile(path) {
        // Crude extension-based recognition
        let pathStr = path.toString();
        let isImage = /\.(?:jpe?g|png)$/i.test(pathStr);
        console.log("Preview: testing for image heuristic", pathStr, isImage)
        return isImage
    }

    function isTextFile(path) {
        // Crude extension-based recognition
        // TODO put common text extensions here
        let pathStr = path.toString();
        let isText = /\.(?:txt|xml|json|html?|ini)$/i.test(pathStr);
        console.log("Preview: testing for text heuristic", pathStr, isText)
        return isText
    }

    function isVideoFile(path) {
        // Crude extension-based recognition
        let pathStr = path.toString();
        let isVideo = /\.(?:mp4|mpeg4|mkv|avi)$/i.test(pathStr);
        console.log("Preview: testing for video heuristic", pathStr, isVideo)
        return isVideo
    }

    ColumnLayout {
        anchors.fill: parent

        // TODO should only print filename here at least
        // The width of the label is expanding the preview element as well!
        NiceLabel {
            text: activeContentsPanel.contentsModel.lastSelectedUrl !== Qt.url("") ?
                      "Selected: " + activeContentsPanel.contentsModel.lastSelectedUrl.toString() :
                      "No selection"
        }

        Loader {
            Layout.fillHeight: true
            Layout.fillWidth: true
            asynchronous: true
            sourceComponent: {
                if (!previewRoot.visible) {
                    return null
                }

                const lastUrl = activeContentsPanel.contentsModel.lastSelectedUrl

                if (isImageFile(lastUrl)) {
                    return imageComponent
                }

                if (isTextFile(lastUrl)) {
                    // TODO should be configurable
                    let sizeTruncation = 1024 ** 2; // 1 MB limit so not to slow down
                    previewRoot.textPreview = utilities.readTextFile(activeContentsPanel.contentsModel.lastSelectedUrl, sizeTruncation)
                    return textComponent
                }

                if (isVideoFile(lastUrl)) {

                }

                return null
            }
        }
    }
}
