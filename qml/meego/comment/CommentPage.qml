// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import "../../js/api.js" as Api
import "../"
import "../../utility"

MyPage{

    tools: ToolBarLayout{
        ToolIcon{
            iconId: "toolbar-back"
            onClicked: {
                pageStack.pop()
            }
        }
    }

    HeaderView{
        id: header

        textColor: command.style.newsContentFontColor
        font.pixelSize: command.style.metroTitleFontPixelSize
        title: qsTr("Comment")
        height: screen.currentOrientation===Screen.Portrait?72:56
    }

}
