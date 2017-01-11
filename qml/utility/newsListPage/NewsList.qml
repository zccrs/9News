// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.star.utility 1.0
import "../"
import "../../js/api.js" as Api

ListView{
    id: root

    property ListModel parentListModel: ListView.view.model
    property bool isBusy: false
    property string lastNewsId
    //记录列表中最后一个新闻条目的新闻id

    delegate: listDelegate
    spacing: 10
    footer: componentFooter

    model: ListModel{
        id: mymodel
    }

    function loadNewsList(){//加载新闻列表
        if(isBusy){
            return
            //如果忙碌就return
        }

        if(articles==null){
            isBusy = true
            //设置为忙碌的
            utility.httpGet(root, "getNewsFinished(QVariant,QVariant)", newsUrl)
            return
        }

        for(var i in articles){
            mymodel.append({"model_componentData": articles[i],
                               "model_enableAnimation": enableAnimation,
                               "contentComponent": componentListItem})
            //model_enableAnimation属性是记录是否开启图片动画
        }
        lastNewsId = articles[i]._id//保存最后一个新闻的id
    }

    function updateList(){//更新新闻列表
        if(isBusy){
            return
            //如果忙碌就return
        }

        parentListModel.setProperty(index, "enableAnimation", true)
        //将允许动画设置为true
        parentListModel.setProperty(index, "articles", null)
        parentListModel.setProperty(index, "covers", null)
        parentListModel.setProperty(index, "listContentY", 0)
        //将所有保存的数据都置为初始状态
        mymodel.clear()
        mymodel.append({"model_componentData": root,
                           "model_enableAnimation": enableAnimation,
                           "contentComponent": componentListHeader})
        //将大海报添加进来
        loadNewsList()
    }

    function getNewsFinished(error, data){//加载新闻完成
        isBusy = false
        //取消忙碌状态

        if(error){
            command.showBanner(qsTr("News update failed, will try again."))
            return
        }
        data = JSON.parse(utility.fromUtf8(data))

        if(!data.error){
            parentListModel.setProperty(index, "articles", data.articles)
            loadNewsList()
            var message = qsTr("Update completed ")+data.pager.pagesize+qsTr(" news")
            command.showBanner(message)
            //显示提示
        }else{
            command.showBanner(data.error)
        }
    }

    function getMoreNewsFinished(error, data){//获取更多新闻完成
        isBusy = false
        //取消忙碌状态

        if(error){
            command.showBanner(qsTr("News load failed, will try again."))
            return
        }
        data = JSON.parse(data)

        if(data.error==0){
            for(var i in data.articles){
                mymodel.append({"model_componentData": data.articles[i],
                                   "model_enableAnimation": enableAnimation,
                                   "contentComponent": componentListItem})
                //model_enableAnimation属性是记录是否开启图片动画
            }
            parentListModel.setProperty(index, "articles", articles.concat(data.articles))
            //合并两个数组，储存新获取的新闻
            lastNewsId = data.articles[i].aid//保存最后一个新闻的id

            var message = qsTr("Add completed ")+data.pager.pagesize+qsTr(" news")
            command.showBanner(message)
            //显示提示
        }else{
            command.showBanner(data.error)
        }
    }

    function addMoreNews(){//加载更多新闻
        if(isBusy){
            return
        }
        isBusy = true
        //设置为忙碌的
        var newUrl = Api.getMoreNewsUrlByCurrentUrl(newsUrl, lastNewsId)
        parentListModel.setProperty(index, "newsUrl", newUrl)
        //设置新的url

        utility.httpGet(root, "getMoreNewsFinished(QVariant,QVariant)", newsUrl)
        //去获取更多新闻
    }

    function switchOrderMode(){//切换新闻排列模式（按时间/人气排列）
        if(isBusy)
            return

        var value = dataOrder?"views":""
        parentListModel.setProperty(index, "dataOrder", !dataOrder)
        //设置新闻排列模式
        parentListModel.setProperty(index, "newsUrl", Api.setUrlProperty(newsUrl, "order", value))
        //设置一下url中的order参数的值

        updateList()
        //重新加载新闻
    }

    Component{
        id: componentListHeader

        NewsListHeaderCompoent{
            id: listHeader
        }
    }
    Component{
        id: componentListItem

        NewsListCompoent{}
    }

    Component{
        id: listDelegate

        Loader{
            property variant componentData: model_componentData
            property bool enableAnimation: model_enableAnimation

            width: parent.width
            sourceComponent: contentComponent

            Component.onDestruction: {
                parentListModel.setProperty (index, "model_enableAnimation", false)
                //当组件被销毁时把enableAnimation属性置为false，这样下次再被创建时就图片就不会再有动画效果了
            }
        }
    }

    Component{
        id: componentFooter

        Item{
            width: newsList.width
            height: textLoadMoreNews.implicitHeight+40
            Text{
                id: textLoadMoreNews
                text: qsTr("load more...")
                anchors.centerIn: parent
                visible: newsList.count>1
                color: newsList.isBusy?command.style.inactiveFontColor:command.style.newsTitleFontColor
                font.pixelSize: command.newsTitleFontSize
            }
            //newsList对象在MainPage中，因为在compoentFooter中无法引用的root对象，所以这也是不得已而为之
            MouseArea{
                anchors.fill: parent
                enabled: !newsList.isBusy
                onClicked: {
                    utility.consoleLog("将要增加新闻")
                    newsList.addMoreNews()//增加新闻
                }
            }
        }
    }

    /*Text{
        id: pullDownItem

        property bool active: y>implicitHeight*1.5

        text: active?qsTr("loosen refresh"):qsTr("pull down refresh")
        color: "#888"
        anchors.horizontalCenter: parent.horizontalCenter
        y:{
            if(root.contentY<0)
                return -root.contentY-implicitHeight-10
            else
                return -implicitHeight
        }
    }

    MonitorMouseEvent{
        target: root
        anchors.fill: parent

        onMouseRelease: {
            if(pullDownItem.active){
                updateList()
                //刷新新闻列表
            }
        }
    }*/

    PullDownMenu{
        id: pullDownMenu

        width: parent.width
        listView: root
        menuItemPixelSize: command.newsTitleFontSize

        onTrigger: {
            if(index==0){
                if(dataOrder){
                    utility.consoleLog("将要按人气排行")
                    setMenuText(qsTr("Date order"))
                }else{
                    utility.consoleLog("将要按日期排行")
                    setMenuText(qsTr("Popularity order"))
                }
                switchOrderMode()//切换新闻排列模式
            }else if(index==1){
                updateList()
                //刷新新闻列表
            }
        }

        Component.onCompleted: {
            addMenu(qsTr("Popularity order"))
        }

        Timer{
            running: true
            interval: 100
            onTriggered: {
                parent.addMenu(qsTr("Immediate refresh"))
            }
        }
    }

    ToTopIcon{
        target: root
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        width: command.style.toUpIconWidth
        z:1
    }

    Component.onCompleted: {
        mymodel.append({"model_componentData": root,
                           "model_enableAnimation": enableAnimation,
                           "contentComponent": componentListHeader})
        //将大海报添加进来
        loadNewsList()//加载新闻
        contentY = listContentY
    }

    Component.onDestruction: {//当组件被销毁时
        parentListModel.setProperty(index, "listContentY", contentY)
        //设置model中存放的属于自己的属性
        parentListModel.setProperty(index, "enableAnimation", false)
        //将允许动画设置为false
    }

    onMovementStarted: {
        if(command.fullscreenMode)
            main.showToolBar = false
    }
    onMovementEnded: {
        if(command.fullscreenMode)
            main.showToolBar = true
    }
}
