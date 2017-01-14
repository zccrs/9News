// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.zccrs.widgets 1.0
import "../utility"
import "./customwidget"
import "../utility/newsListPage"
import "../js/api.js" as Api
import "../js/server.js" as Server

MyPage{
    id: root

    property bool isBusy: false
    //记录是否正在忙碌，例如正在获取新闻分类
    signal refreshNewsList
    //发射信号刷新当前新闻列表

    function getNewsCategorysFinished(error, data){
        isBusy = false
        //取消忙碌状态

        //当获取新闻种类结束后调用此函数
        if(error){//如果网络请求出错
            command.showBanner(qsTr("Failed to load the news categorys, will try again."))
            return
        }

        data = JSON.parse(data)

        if (!data.error) {
            for(var i in data.categorys){
                metroView.addItem(data.titles[i], data.categorys[i])
            }
        } else {
            command.showBanner(data.error)
        }
    }

    function updateAllNewsCategorys(){//重新加载所有分类的新闻
        if(isBusy)//如果正在忙就返回
            return

        isBusy = true
        //取消忙碌状态

        metroView.clearPage()
        //先清除所有分类
        metroView.addItem(qsTr("all news"))
        //先增加全部新闻的页
        utility.httpGet(getNewsCategorysFinished, Api.newsCategorysUrl)
        //去获取新闻分类
    }

    HeaderView{
        id: headerView
        height: metroView.titleBarHeight
    }

    tools: ToolBarSwitch{
        id: toolBarSwitch
        toolBarComponent: compoentToolBarLayout
    }

    Component{
        id: compoentToolBarLayout

        MyToolBarLayout{
            MyToolIcon{
                iconId: "toolbar-home"
                onClicked: {
                    metroView.activation(0)
                }
            }
            MyToolIcon{
                iconSource: command.getIconSource(command.style.toolBarInverted, "skin", "png")
                onClicked: {
                    command.themeSwitch()
                }
            }
            MyToolIcon{
                iconId: "toolbar-search"
                onClicked: {
                    toolBarSwitch.toolBarComponent = compoentCommentToolBar
                }
            }
            MyToolIcon{
                iconId: "toolbar-view-menu"
                onClicked: {
                    mainMenu.open()
                }
            }
        }
    }

    Component{
        id: compoentCommentToolBar

        TextAreaToolBar{
            property string oldText: ""
            //记录上次输入的搜索内容
            property int currentNewsPage: 0
            //记录是在哪个新闻页面点击的搜索

            invertedTheme: command.style.toolBarInverted
            rightButtonIconId: "toolbar-search"

            onLeftButtonClick: {
                metroView.pageInteractive = true
                toolBarSwitch.toolBarComponent = compoentToolBarLayout
                if(metroView.getTitle(metroView.currentPageIndex)==qsTr("Searched result")){
                    metroView.removePage(metroView.currentPageIndex)
                    metroView.activation(currentNewsPage)
                }
            }
            onRightButtonClick: {
                if(oldText == textAreaContent||textAreaContent=="")
                    return//如果搜索内容没有变化或者为空则不搜索

                oldText = textAreaContent
                if(metroView.getTitle(metroView.currentPageIndex)==qsTr("Searched result")){
                    metroView.setProperty(metroView.currentPageIndex,
                                          "newsUrl",
                                          Api.getNewsUrlByCategory("", textAreaContent))
                    refreshNewsList()//刷新新闻
                }else{
                    metroView.addItem(qsTr("Searched result"), "", textAreaContent)
                    metroView.activation(metroView.pageCount-1)
                    metroView.pageInteractive = false
                }
            }

            Component.onCompleted: {
                currentNewsPage = metroView.currentPageIndex
                //记录下来当前页面
            }
        }
    }

    MetroView{
        id: metroView

        anchors.fill: parent
        titleSpacing: 15
        titleMaxFontSize: command.style.metroTitleFontPixelSize

        function addItem(title, category, keyword, order){
            var obj = {
                "articles": null,//所有大海报的数据
                "covers": null,//所有新闻的数据
                "listContentY": 0,//新闻列表的y值
                "enableAnimation": true,//是否允许列表动画
                "dataOrder": true,//是否按日期排序（否则是按人气）
                "newsUrl": Api.getNewsUrlByCategory(category, keyword, order),
                //新闻列表的获取地址
                "imagePosterUrl": keyword?"":Api.getPosterUrlByCategory(category)
                //大海报的获取地址
            }
            addPage(title, obj)
        }

        delegate: NewsListPage{
            id: newsList

            width: metroView.width
            height: metroView.height-metroView.titleBarHeight

            Connections{
                target: root
                onRefreshNewsList:{
                    newsList.updateList()
                    //如果收到刷新列表的信号就重新获取新闻列表
                }
            }
        }

        Component.onCompleted: {
            updateAllNewsCategorys()
            //加载所有分类的信息
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
     MyMenu {
         id: mainMenu
         // define the items in the menu and corresponding actions
         content: MenuLayout {
             MyMenuItem {
                 text: qsTr("Personal Center")
                 onClicked: {
                     if(Server.userData.auth){
                         pageStack.push(Qt.resolvedUrl("./usercenter/UserCenterPage.qml"))
                     }else{
                         pageStack.push(Qt.resolvedUrl("./usercenter/LoginPage.qml"))
                     }
                 }
             }
             MyMenuItem {
                 text: qsTr("Refresh All News Categorys")
                 onClicked: {
                     updateAllNewsCategorys()
                     //更新所有分类的新闻
                 }
             }
             MyMenuItem {
                 text: qsTr("Settings")
                 onClicked: {
                     pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
                 }
             }
             MyMenuItem {
                 text: qsTr("About")
                 onClicked: {
                     pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                 }
             }
         }
     }
}
