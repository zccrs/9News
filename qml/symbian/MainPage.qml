// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import com.stars.widgets 1.0
import "../utility"
import "../utility/metro"
import "../utility/newsPage"

MyPage{
    property bool isQuit: false
    //判断此次点击后退键是否应该退出

    HeaderView{
        id: headerView

        invertedTheme: command.invertedTheme
        height: (screen.currentOrientation===Screen.Portrait?
                     privateStyle.tabBarHeightPortrait:privateStyle.tabBarHeightLandscape)+20
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
            iconSource: "qrc:/images/skin"+(command.invertedTheme?"_invert.png":".png")
            onClicked: {
                command.invertedTheme=!command.invertedTheme
            }
        }
        ToolButton{
            iconSource: "toolbar-refresh"
            platformInverted: command.invertedTheme
        }

        ToolButton{
            iconSource: "toolbar-menu"
            platformInverted: command.invertedTheme

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

        function addItem(title, newsUrl, imagePosterUrl){
            var obj = {
                "articles": null,
                "covers": null,
                "listContentY": 0,
                "newsUrl": "http://api.9smart.cn/news",
                "imagePosterUrl": "http://api.9smart.cn/covers"
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
                    platformInverted: command.invertedTheme
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    text: "more"
                    font.pointSize: 7
                }
            }
        }

        Component.onCompleted: {
            metroView.addItem("最新新闻")
            metroView.addItem("热门新闻")
            metroView.addItem("热门评论")
            metroView.addItem("MeeGo专栏")
            metroView.addItem("Symbian专栏")
            metroView.addItem("旗鱼专栏")
        }
    }
    Connections{
        target: command
        onGetNews:{

        }
    }
}
