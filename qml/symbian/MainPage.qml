// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import com.stars.widgets 1.0
import "../utility"
import "../utility/metro"
import "../utility/newsListPage"
import "../js/api.js" as Api

MyPage{
    id: root

    property bool isQuit: false
    //判断此次点击后退键是否应该退出
    signal refreshNewsList
    //发射信号刷新当前新闻列表

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
        height: screen.currentOrientation===Screen.Portrait?
                     privateStyle.tabBarHeightPortrait:privateStyle.tabBarHeightLandscape
    }

    tools: CustomToolBarLayout{
        platformInverted: command.invertedTheme
        ToolButton{
            iconSource: "toolbar-back"
            platformInverted: command.invertedTheme
            onClicked: {
                if(isQuit){
                    Qt.quit()
                }else{
                    isQuit = true
                    main.showBanner(qsTr("Press again to exit"))
                    timerQuit.start()
                }
            }
        }
        ToolButton{
            iconSource: command.getIconSource("skin", command.invertedTheme)
            onClicked: {
                command.invertedTheme=!command.invertedTheme
            }
        }
        ToolButton{
            iconSource: "toolbar-refresh"
            platformInverted: command.invertedTheme
            onClicked: {
                refreshNewsList()
                //发射信号刷新当前新闻列表
            }
        }

        ToolButton{
            iconSource: "toolbar-menu"
            platformInverted: command.invertedTheme
            onClicked: {
                mainMenu.open()
            }
        }
    }

    Timer{
        //当第一次点击后退键时启动定时器，如果在定时器被触发时用户还未按下第二次后退键则将isQuit置为false
        id: timerQuit
        interval: 2000
        onTriggered: {
            isQuit = false
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
<<<<<<< HEAD
=======
                "enableAnimation": true,
>>>>>>> dev_AfterTheRainOfStars
                "newsUrl": Api.getNewsUrlByCategory(category),
                "imagePosterUrl": Api.getPosterUrlByCategory(category)
            }
            addPage(title, obj)
        }

        delegate: NewsList{
            id: newsList

            width: metroView.width
            height: metroView.height-metroView.titleBarHeight

            footer:Item{
                visible: newsList.count>1
                width: parent.width-40
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter
                Button{
                    platformInverted: command.invertedTheme
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("load next page")
                    font.pointSize: 7

                    onClicked: {
                        newsList.addMoreNews()//增加新闻
                    }
                }
            }

            Connections{
                target: root
                onRefreshNewsList:{
                    newsList.updateList()
                    //如果收到刷新列表的信号就重新获取新闻列表
                }
            }
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

    // define the menu
     Menu {
         id: mainMenu
         // define the items in the menu and corresponding actions
         platformInverted: command.invertedTheme
         content: MenuLayout {
             MenuItem {
                 text: qsTr("Search")
                 platformInverted: command.invertedTheme
             }
             MenuItem {
                 text: qsTr("Personal Center")
                 platformInverted: command.invertedTheme
             }
             MenuItem {
                 text: qsTr("Settings")
                 platformInverted: command.invertedTheme
             }
             MenuItem {
                 text: qsTr("About")
                 platformInverted: command.invertedTheme
             }
         }
     }
}
