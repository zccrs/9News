// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListView{
    id: root

    property NewsListHeaderCompoent headerItem

    header: NewsListHeaderCompoent{
        id: listHeader
        Component.onCompleted: {
            headerItem = listHeader
        }
    }
    delegate: NewsListCompoent{}
    spacing: 10

    model: ListModel{
        id: mymodel
    }
    function updateNewsList(){//更新新闻列表
        if(articles==null){
            utility.httpGet(getNewsFinished, newsUrl)
            return
        }

        for(var i in articles){
            mymodel.append({"article": articles[i], "enableAnimation": true})
            //enableAnimation属性是记录是否开启图片动画
        }
    }
    function updateFlipcharts(){//更新大海报列表
        if(covers==null){
            utility.httpGet(getImagePosterFinished, imagePosterUrl)
            return
        }

        root.headerItem.addFlipcharts(covers)
    }

    function getNewsFinished(error, data){//加载新闻完成
        if(error){
            return
        }
        data = JSON.parse(data)

        if(data.error==0){
            ListView.view.model.setProperty(index, "articles", data.articles)
            updateNewsList()
        }
    }
    function addMoreNews(){//加载更多新闻

    }

    function getImagePosterFinished(error, data){//加载大海报完毕
        if(error){
            return
        }
        data = JSON.parse(data)

        if(data.error==0){
            ListView.view.model.setProperty(index, "covers", data.covers)
            updateFlipcharts()
        }
    }

    Component.onCompleted: {
        updateNewsList()
        updateFlipcharts()//更新大海报列表
        contentY = listContentY
    }
    Component.onDestruction: {//当组件被销毁时
        ListView.view.model.setProperty(index, "listContentY", contentY)
        //设置model中存放的属于自己的属性
    }
}
