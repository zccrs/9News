// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import "../utility"

MyPage{
    id: root

    property int newsId: -1
    property string newsTitle

    tools: CustomToolBarLayout{
        platformInverted: command.invertedTheme
        ToolButton{
            iconSource: "toolbar-back"
            platformInverted: command.invertedTheme
            onClicked: {
                pageStack.pop()
            }
        }
    }

    HeaderView{
        id: headerView

        invertedTheme: command.invertedTheme
        height: newsPage.titleHeight
    }

    ReadNewsPage{
        id: newsPage
        anchors.fill: parent
        newsId: root.newsId
        newsTitle: root.newsTitle
    }

    onStatusChanged: {
        newsPage.activePage = status===PageStatus.Active
    }
}
