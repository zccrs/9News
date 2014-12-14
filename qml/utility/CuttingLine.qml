// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    property bool invertedTheme: false
    property alias annotation: text_annotation.text

    height: annotation!=""?text_annotation.implicitHeight:2
    width: parent.width

    Item{
        anchors.left: text_annotation.right
        anchors.leftMargin: annotation==""?0:10
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 2

        Rectangle{
            height: 1
            width: parent.width
            color: invertedTheme?"#ccc":"#333"
        }
        Rectangle{
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: invertedTheme?"#fafafa":"#555"
        }
    }

    Text{
        id: text_annotation
        color: "#888"
    }
}
