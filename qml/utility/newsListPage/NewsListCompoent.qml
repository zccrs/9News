// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.stars.widgets 1.0

Item{
    id: root

    property int newsId: -1
    //此属性记录新闻Id

    width: parent.width
    height: Math.max(titleText.implicitHeight, loader_titleImage.height)+
            newsInfos.height+loader_imageList.height+10

    Loader{
        id: loader_titleImage
        property url imageUrl 
    }

    Text{
        id: titleText

        anchors.left: loader_titleImage.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: loader_titleImage.top
        wrapMode: Text.WordWrap
        color: command.invertedTheme?"black":"#ccc"
        font.pointSize: command.newsTitleFontSize
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            command.getNews(newsId, titleText.text)
        }
    }
    Loader{
        id: loader_imageList

        property variant thumbs

        anchors.top: titleText.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width-20
    }

    Item{
        id: newsInfos

        width: parent.width-20
        height: newsSource.implicitHeight+10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        Text{
            id: newsSource
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: command.style.newsInfosFontPointSize
            color: "#888"
        }
        Text{
            id: dateTime
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: newsSource.font.pointSize
            color: "#888"
        }
    }

    Component{
        id: compoent_titleImage

        Image{
            id: titleImage
            source: imageUrl
            width: 60
            height: 60

            NumberAnimation on y {
                id: imageAnimation
                duration: 100
                running: false
                from: -titleImage.height/2; to: 0
                easing.type: Easing.OutQuad
            }
            onStatusChanged: {
                if(status == Image.Ready&&enableAnimation){
                    imageAnimation.start()
                }
            }
            Component.onCompleted: {
                sourceSize = Qt.size(60,60)
                parent.height = height
            }
        }
    }

    Component{
        id: compoent_imageList

        ListView{
            clip: true
            width: parent.width
            orientation: ListView.Horizontal
            spacing: 5
            delegate: Image{
                id: listImage
                source: imageUrl
                sourceSize.height: 60

                NumberAnimation on y {
                    id: imageAnimation
                    running: false
                    duration: 100
                    from: -listImage.implicitHeight/2; to: 0
                    easing.type: Easing.OutQuad
                }
                onStatusChanged: {
                    if(status == Image.Ready&&enableAnimation){
                        imageAnimation.start()
                    }
                }
            }

            model: ListModel{
                id: mymodel
            }

            Component.onCompleted: {
                for(var i in thumbs){
                    mymodel.append({"imageUrl": thumbs[i].thumburl})
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    command.getNews(newsId, titleText.text)
                }
            }
        }
    }

    Component.onCompleted: {
        if(article){
            newsId = article.aid
            titleText.text = article.topic
            newsSource.text = article.source
            dateTime.text = command.fromTime_t(article.dateline)

            var thumbs = article.thumbs
            if(thumbs){
                if(thumbs.length==1){
                    loader_titleImage.x = 10
                    loader_titleImage.width = 50
                    loader_titleImage.height = 50
                    loader_titleImage.imageUrl = thumbs[0].thumburl
                    loader_titleImage.sourceComponent = compoent_titleImage
                }else{
                    loader_imageList.height = 50
                    loader_imageList.thumbs = thumbs
                    loader_imageList.sourceComponent = compoent_imageList
                }
            }
        }
    }

    Rectangle{
        width: parent.width
        height: 1
        anchors.bottom: line.top
        color: command.invertedTheme?"#ccc":"#333"
    }
    Rectangle{
        id: line
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: command.invertedTheme?"#fafafa":"#555"
    }

    Component.onDestruction: {
        ListView.view.model.setProperty (index, "enableAnimation", false)
        //当组件被销毁时把enableAnimation属性置为false，这样下次再被创建时就图片就不会再有动画效果了
    }
}
