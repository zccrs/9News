// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.stars.widgets 1.0
import "../utility"
import "../utility/metro"
import "../utility/newsListPage"
import "../js/api.js" as Api

MyPage{

    function getNewsCategorysFinished(error, data){
        //当获取新闻种类结束后调用此函数
        if(error)//如果网络请求出错
            return

        data = JSON.parse(data)
        if(data.error==0){
            for(var i in data.categorys){
                metroView.addItem(data.titles[i], data.categorys[i])
            }
        }
    }

    HeaderView{
        id: headerView
        invertedTheme: command.invertedTheme
        height: screen.currentOrientation===Screen.Portrait?72:56
    }

    tools: ToolBarLayout{
        ToolIcon{
            iconId: "toolbar-home"
        }

        ToolIcon{
            iconSource: command.getIconSource("skin", command.invertedTheme)
            onClicked: {
                command.invertedTheme=!command.invertedTheme
            }
        }
        ToolIcon{
            iconId: "toolbar-refresh"
        }
        ToolIcon{
            iconId: "toolbar-view-menu"
        }
    }

    MetroView{
        id: metroView
        anchors.fill: parent
        titleBarHeight: headerView.height
        titleSpacing: 25

        function addItem(title, category){
            var obj = {
                "articles": null,
                "covers": null,
                "listContentY": 0,
                "enableAnimation": true,
                "newsUrl": Api.getNewsUrlByCategory(category),
                "imagePosterUrl": Api.getPosterUrlByCategory(category)
            }
            addPage(title, obj)
        }

        Component.onCompleted: {
            metroView.addItem(qsTr("all news"))
            //先去获取全部新闻
            utility.httpGet(getNewsCategorysFinished, Api.newsCategorysUrl)
            //去获取新闻分类
        }
    }
    Connections{
        target: command
        onGetNews:{
            //如果某新闻标题被点击（需要阅读此新闻）
            pageStack.push(Qt.resolvedUrl("NewsContentPage.qml"),
                           {newsId: newsId, newsTitle: title})
        }
    }
}
