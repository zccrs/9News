// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1
import QtMobility.systeminfo 1.2
import "./customwidget"
import "../js/server.js" as Server

MyPageStackWindow
{
    id:main

    property string deviceModel: deviceInfo.model

    showStatusBar:true
    initialPage: MainPage{}

    style: PageStackWindowStyle{
        inverted: command.style.invertedTheme!=true
        background: command.style.backgroundImage!=""?command.style.backgroundImage:
                        "image://theme/meegotouch-applicationpage-background"+__invertedString
        portraitBackground: command.style.backgroundImage
        landscapeBackground: command.style.backgroundImage
    }

    Component.onCompleted: {
        Server.initServer(utility);
    }
    Component.onDestroyed: {
        Server.aboutDestory();
    }

    function updateStyle(){
        if(command.style.invertedTheme==true)
            theme.inverted = false
        else
            theme.inverted = true

        main.children[0].opacity = command.style.backgroundImageOpacity
    }

    InfoBanner {
        id: banner

        y: 35
        timerShowTime: 2000
    }

    Connections{
        target: command
        onShowBanner:{
            banner.text = message
            banner.show()
        }
    }

    Connections{
        target: command
        onStyleChanged:{
            updateStyle()
        }
    }

    Component.onCompleted: {
        var toolBar_backImage = pageStack.toolBar.children[4]
        toolBar_backImage.source = ""
        toolBar_backImage.height = 72
        updateStyle()
    }

    DeviceInfo {
        id: deviceInfo
    }
}
