// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.star.widgets 1.0

Item{
    property bool invertedTheme: false
    property alias title: mytext.text
    property alias font: mytext.font

    width: parent.width

    CuttingLine{
        anchors.bottom: parent.bottom
        width: parent.width
        invertedTheme: parent.invertedTheme
    }

    Text{
        id: mytext
        anchors.verticalCenter: parent.verticalCenter
        x:10
    }
}
