// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import QtWebKit 1.0

PageStackWindow{
    id:main
    showStatusBar:true
    showToolBar: true
    platformSoftwareInputPanelEnabled :true
    platformInverted: command.invertedTheme

    initialPage: MainPage{}

    function showBanner(string){
        banner.text = string
        banner.open()
    }

    InfoBanner {
        id: banner
        timeout: 2000
        platformInverted: main.platformInverted
    }

    Image{
        anchors.top: parent.top
        anchors.topMargin: privateStyle.statusBarHeight
        anchors.left: parent.left
        source: "qrc:/images/mask_leftTop.png"
    }
    Image{
        anchors.top: parent.top
        anchors.topMargin: privateStyle.statusBarHeight
        anchors.right: parent.right
        source: "qrc:/images/mask_rightTop.png"
    }
    Image{
        anchors.bottom: parent.bottom
        source: "qrc:/images/mask_leftBottom.png"
    }
    Image{
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        source: "qrc:/images/mask_rightBottom.png"
    }
}
