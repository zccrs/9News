// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1

PageStackWindow
{
    id:main

    showStatusBar:true
    initialPage: MainPage{}

    style: PageStackWindowStyle{
        inverted: command.style.invertedTheme==true
        background: command.style.backgroundImage
        portraitBackground: command.style.backgroundImage
        landscapeBackground: command.style.backgroundImage
    }

    function updateStyle(){
        if(command.style.invertedTheme==true)
            theme.inverted = false
        else
            theme.inverted = true
        main.children[0].opacity = command.style.backgroundImageOpacity
    }

    Rectangle{//图片遮罩
        parent: main.children[2]
        anchors.fill: parent
        color: command.style.backgroundImageMaskColor
        opacity: command.style.backgroundImageMaskOpacity
        visible: command.style.showBackgroundImageMask
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
