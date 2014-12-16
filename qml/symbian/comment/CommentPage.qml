// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import "../../js/api.js" as Api
import "../"
import "../../utility"

MyPage{

    tools: CustomToolBarLayout{
        invertedTheme: command.invertedTheme

        ToolButton{
            iconSource: "toolbar-back"
            platformInverted: command.invertedTheme
            onClicked: {
                pageStack.pop()
            }
        }
    }

    HeaderView{
        id: header
        invertedTheme: command.invertedTheme
        font.pixelSize: command.style.metroTitleFontPixelSize
        title: qsTr("Comment")
        height: screen.currentOrientation===Screen.Portrait?
                     privateStyle.tabBarHeightPortrait:privateStyle.tabBarHeightLandscape
    }

}
