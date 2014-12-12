// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.stars.utility 1.0

ListView{
    id: root

    property ListModel parentListModel: ListView.view.model
    property bool isBusy: false

    signal updateFlipcharts

    delegate: listDelegate
    spacing: 10

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
    }

    function updateList(){//更新新闻列表
        if(isBusy){
            return
            //如果忙碌就return
        }

        parentListModel.setProperty(index, "enableAnimation", true)
        //将允许动画设置为true
        parentListModel.setProperty(index, "articles", null)
        parentListModel.setProperty(index, "listContentY", 0)
        mymodel.clear()
        updateFlipcharts()
        loadNewsList()
    }

    function getNewsFinished(error, data){//加载新闻完成
        isBusy = false
        //取消忙碌状态

        if(error){
            return
        }
        data = JSON.parse(data)

        if(data.error==0){
            parentListModel.setProperty(index, "articles", data.articles)
            loadNewsList()
        }
    }
    function addMoreNews(){//加载更多新闻
        if(isBusy){
            return
        }
        //isBusy = true
        //设置为忙碌的
    }

    Component{
        id: componentListHeader

        NewsListHeaderCompoent{
            id: listHeader
        }
    }
    Component{
        id: componentListItem

        NewsListCompoent{

        }
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

    MonitorMouseEvent{
        anchors.fill: parent

        target: root

        onMousePress: {
            console.log("press")
        }
        onMouseRelease: {
            console.log("release")
        }
    }
}
