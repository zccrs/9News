// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1

PageStackWindow{
    id:main
    showStatusBar:true
    showToolBar: true
    platformSoftwareInputPanelEnabled :true
    platformInverted: command.invertedTheme

    initialPage: MainPage{}

    Label {
        text:"久闻"
        x:10
        font.pixelSize: 18
    }

    InfoBanner {
        id: banner
        timeout: 2000
        platformInverted: command.invertedTheme
    }

    Image{
        anchors.top: parent.top
        anchors.topMargin: privateStyle.statusBarHeight
        anchors.left: parent.left
        source: "qrc:/images/mask_leftTop.png"
        z: 1
    }
    Image{
        anchors.top: parent.top
        anchors.topMargin: privateStyle.statusBarHeight
        anchors.right: parent.right
        source: "qrc:/images/mask_rightTop.png"
        z: 1
    }
    Image{
        anchors.bottom: parent.bottom
        source: "qrc:/images/mask_leftBottom.png"
        z: 1
    }
    Image{
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        source: "qrc:/images/mask_rightBottom.png"
        z: 1
    }

    Connections{
        target: command
        onShowBanner:{
            banner.text = message
            banner.open()
        }
    }
}
