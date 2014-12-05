// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.stars.widgets 1.0

Item{
    property bool invertedTheme: false
    property alias title: mytext.text

    width: parent.width

    /*MySvgView{
        id: image
        source: "qrc:/images/tab_active_normal_c"+(invertedTheme?"_inverse.svg":".svg")
        width: parent.width
        height: parent.height
    }
    MySvgView{
        id: image_shade
        source: "qrc:/images/shade.svg"
        width: parent.width
        anchors.bottom: parent.bottom
    }*/
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
