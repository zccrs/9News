import QtQuick 1.0
import com.nokia.symbian 1.1
import com.star.widgets 1.0
import com.star.utility 1.0
import "../Components"
import "../JS/utility.js" as Utility

Component {
    ImplicitSizeItem {
        id: root;
        implicitWidth: parent.width;
        implicitHeight: contentColumn.height + constants.marginMedium * 2;

        Item {
            id: paddingItem;
            anchors {
                left: parent.left; leftMargin: constants.marginMedium;
                right: parent.right; rightMargin: constants.marginMedium;
                top: parent.top; topMargin: constants.marginMedium;
                bottom: parent.bottom; bottomMargin: constants.marginMedium;
            }
        }

        property variant thumbsModel: (modelData.thumbs != null ? modelData.thumbs : []);
        Column {
            id: contentColumn;
            anchors.left: paddingItem.left;
            anchors.right: paddingItem.right;
            anchors.top: paddingItem.top;
            spacing: constants.marginSmall;
            Text {
                id: titleText;
                color: settings.invertedTheme ? "Black" : "White";
                //anchors.left: parent.left; anchors.right: parent.right;
                width: parent.width;
                wrapMode: Text.WrapAnywhere;
                text: modelData.topic;
            }
            ListView {
                id: thumbsListView;
                //anchors.left: parent.left; anchors.right: parent.right;
                clip: true;
                spacing: constants.marginSmall;
                orientation: ListView.Horizontal;
                model: root.thumbsModel;
                width: parent.width;
                height: count == 0 ? 0 : 80;
                delegate: Component {
                    Image {
                        source: modelData.thumburl;
                        height: parent.height;
                        fillMode: Image.PreserveAspectFit;
                    }
                }
            }
            Item {
                //anchors.left: parent.left; anchors.right: parent.right;
                //anchors.bottom: parent.bottom;
                width: parent.width;
                height: sourceText.height;
                Text {
                    id: sourceText;
                    anchors.left: parent.left;
                    text: modelData.source;
                    color: settings.invertedTheme ? "Black" : "White";
                }
                Text {
                    id: timeText;
                    anchors.right: parent.right;
                    text: Utility.humandate(modelData.dateline);
                    color: settings.invertedTheme ? "Black" : "White";
                }
            }
        }
        CuttingLine {
            anchors.bottom: parent.bottom;
            width: parent.width;
            //visible: command.style.cuttingLineVisible;
        }

        Component.onCompleted: {
            //
        }
    }
}


/*
Item {
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
        color: command.style.newsTitleFontColor
        font.pixelSize: command.newsTitleFontSize
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
            font.pixelSize: command.style.newsInfosFontPixelSize
            color: command.style.newsInfoFontColor
        }
        Text{
            id: dateTime
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: newsSource.font.pixelSize
            color: newsSource.color
        }
    }

    Component{
        id: compoent_titleImage

        Image{
            id: titleImage

            source: command.showNewsImage?imageUrl:command.style.defaultImage
            sourceSize{
                width: titleImage.width
                height: titleImage.height
            }

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
                source: command.showNewsImage?imageUrl:command.style.defaultImage
                sourceSize.height: parent.height

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
        var article = componentData
        if(article){
            newsId = article.aid
            titleText.text = article.topic
            newsSource.text = article.source
            dateTime.text = command.fromTime_t(article.dateline)

            var thumbs = article.thumbs
            if(thumbs){
                if(thumbs.length==1){
                    loader_titleImage.x = 10
                    loader_titleImage.width = command.style.titleImageWidth
                    loader_titleImage.height = command.style.titleImageWidth
                    loader_titleImage.imageUrl = thumbs[0].thumburl
                    loader_titleImage.sourceComponent = compoent_titleImage
                }else{
                    loader_imageList.height = command.style.titleImagesListHeight
                    loader_imageList.thumbs = thumbs
                    loader_imageList.sourceComponent = compoent_imageList
                }
            }
        }
    }

    CuttingLine {
        anchors.bottom: parent.bottom;
        width: parent.width;
        visible: command.style.cuttingLineVisible;
    }
}
*/
