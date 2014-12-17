// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.star.widgets 1.0

Item{
    property alias title: mytext.text
    property alias font: mytext.font
    property alias textColor: mytext.color

    width: parent.width

    CuttingLine{
        anchors.bottom: parent.bottom
        width: parent.width
    }

    Text{
        id: mytext
        anchors.verticalCenter: parent.verticalCenter
        x:10
    }
}
