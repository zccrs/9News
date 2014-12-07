// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.stars.widgets 1.0
import "../utility"
import "../utility/metro"
import "../utility/newsListPage"


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
            iconSource: "qrc:/images/skin"+(command.invertedTheme?".png":"_invert.png")
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
                "newsUrl": "http://api.9smart.cn/news"+(category?("?category="+category):""),
                "imagePosterUrl": "http://api.9smart.cn/covers"+(category?("?category="+category):"")
            }
            addPage(title, obj)
        }

        delegate: NewsList{
            id: newsList

            width: metroView.width
            height: metroView.height-metroView.titleBarHeight

            footer:Item{
                visible: newsList.count>0
                width: parent.width-40
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter
                Button{
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("load next page")
                    font.pointSize: 7
                }
            }
        }

        Component.onCompleted: {
            metroView.addItem(qsTr("all news"))
            //先去获取全部新闻
            utility.httpGet(getNewsCategorysFinished, "http://api.9smart.cn/news/categorys")
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
