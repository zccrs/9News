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
        source: "qrc:/images/cuttingLine.png"
    }

    Text{
        id: text_annotation
        font.pixelSize: command.newsTitleFontSize
    }
}
