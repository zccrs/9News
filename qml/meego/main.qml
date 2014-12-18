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

    Binding{
        target: theme
        property: "inverted"
        value: command.style.invertedTheme
    }
    Connections{
        target: command
        onStyleChanged:{
            theme.inverted = !command.style.invertedTheme
            console.log(toolBarStyle.background)
            console.log(style.portraitBackground)
        }
    }

    Binding{
        target: pageStack.toolBar
        property: "platformStyle"

        value: ToolBarStyle{
            id: toolBarStyle

            property url oldBackImage: "image://theme/meegotouch-toolbar-" +
                                       ((screen.currentOrientation == Screen.Portrait || screen.currentOrientation == Screen.PortraitInverted) ? "portrait" : "landscape") +
                                       __invertedString + "-background"
            background: command.style.toolBarBackgroundImage!=""?
                            command.style.toolBarBackgroundImage:
                            oldBackImage
        }
    }
}
