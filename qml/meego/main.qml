// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1
import "inheritProperties.js" as Saa

PageStackWindow
{
    id:main

    showStatusBar:true
    initialPage: MainPage{}

    style: PageStackWindowStyle{
        background: command.style.backgroundImage
        portraitBackground: command.style.backgroundImage
        landscapeBackground: command.style.backgroundImage
    }

    function updateStyle(){
        theme.inverted = !command.style.invertedTheme
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
}
