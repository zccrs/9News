// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    property alias annotation: text_annotation.text
    property alias textColor: text_annotation.color

    height: annotation!=""?text_annotation.implicitHeight:2
    width: parent.width

    Image{
        anchors.left: text_annotation.right
        anchors.leftMargin: annotation==""?0:10
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 2
        sourceSize.width: width
        source: command.getIconSource(true, "cuttingLine", "png", true)
    }

    Text{
        id: text_annotation
    }
}
