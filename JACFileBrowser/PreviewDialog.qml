import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs


Dialog {
    property string name

    id: dialog
    modal: true

    width: parent.width
    height: parent.height

    //anchors.: parent
    Item {
        focus: true

        NiceLabel {
            text: name
        }

        Keys.onPressed: (e) => console.log(e)
    }
}
