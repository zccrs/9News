// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtWebKit 1.0

Item{
    property int newsId: -1
    property string newsTitle: ""
    property bool activePage: false
    property alias titleHeight: titleItems.height

    function getNewsFinished(error, data){
        //获取新闻内容完成
        if(error){
            return
            //如果网络请求过程中出错了就直接return
        }

        data = JSON.parse(data)
        if(data.error==0){
            //如果服务器没有返回错误
            var reg = /\[img=\d{3},\d{3}\][^\[]+/
            var content = data.article.content

            var pos = 0
            var imgs = content.match(reg)

            for(var i in imgs){
                var img_pos = content.indexOf(imgs[i])
                if(img_pos==-1)
                    return
                var text = content.substring(pos, img_pos)
                mymodel.append({
                            "contentType": "text",
                            "contentHtml": textToHtml(text),
                            "imageUrl": ""
                            })

                var img_url = imgs[i].substring(13, imgs[i].length)

                mymodel.append({
                            "contentType": "image",
                            "imageUrl": img_url
                            })
                pos = img_pos+imgs[i].length
            }
            var text = content.substring(pos, content.length)
            if(text!=""){
                mymodel.append({
                            "contentType": "text",
                            "contentHtml": text
                            })
            }
        }
    }

    function textToHtml(text, width){
        return "<html><style>*{padding:0;margin:0;}body{background-color:#F1F1F1;width:"+width+"px }</style><body>"+text+"</body></html>"
    }

    onNewsIdChanged: {
        utility.httpGet(getNewsFinished, "http://api.9smart.cn/new/"+newsId)
        //去获取新闻内容
    }
    onActivePageChanged: {
        if(activePage&&newsTitle!=""){
            textTitle.text = newsTitle
            titleAnimation.start()
        }
    }

    Item{
        id: titleItems

        y:-height
        width: parent.width-20
        height: textTitle.implicitHeight+10
        anchors.horizontalCenter: parent.horizontalCenter

        Text{
            id: textTitle

            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.WordWrap
        }

        NumberAnimation on y{
            id: titleAnimation
            duration: 800
            running: false
            easing.type: Easing.OutElastic
            to: 0
        }
    }

    ListView{
        id: newsContentList

        anchors.left: titleItems.left
        anchors.right: titleItems.right
        anchors.top: titleItems.bottom
        anchors.bottom: parent.bottom
        clip: true

        model: ListModel{
            id: mymodel
        }
        delegate: newsContentListDelegate
    }

    Component{
        id: newsContentListDelegate

        Loader{
            id: loaderNewsContent

            property string componentData: contentType=="image"?imageUrl:contentHtml

            width: parent.width
            opacity: 0
            sourceComponent: contentType=="image"?componentImage:componentText

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }

            Component.onCompleted: {
                opacity = 1
            }
        }
    }

    Component{
        id: componentText

        WebView{
            width: parent.width
            preferredWidth: width
            html: textToHtml(componentData, width)
        }
    }

    Component{
        id: componentImage

        Image{
            source: componentData
            width: Math.min(parent.width, sourceSize.width)
            height: width/sourceSize.width*sourceSize.height

            smooth: true
        }
    }
}
