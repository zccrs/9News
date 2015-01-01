import QtQuick 1.0

Item {
    height: annotation!=""?text_annotation.implicitHeight:2
    width: parent.width
    Image{
        anchors.left: text_annotation.right
        anchors.leftMargin: annotation==""?0:10
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        source: "../Resources/gfx/cuttingLine.png";
    }
}
