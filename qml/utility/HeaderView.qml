// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.star.widgets 1.0

Item{
    property bool invertedTheme: false
    property alias title: mytext.text
    property alias font: mytext.font

    width: parent.width

    Rectangle{
        width: parent.width
        height: 1
        anchors.bottom: line.top
        color: invertedTheme?"#ccc":"#333"
    }
    Rectangle{
        id: line
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: invertedTheme?"#fafafa":"#555"
    }

    Text{
        id: mytext
        anchors.verticalCenter: parent.verticalCenter
        x:10
        font.pointSize: 7
    }
}
