// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../js/api.js" as Api

Item{
    id: root

    property int newsId: -1
    property string newsTitle: ""
    property bool activePage: false
    property alias titleHeight: titleItems.height
    property Item imagesBrowse

    function getNewsFinished(error, data){
        //获取新闻内容完成
        if(error){
            return
            //如果网络请求过程中出错了就直接return
        }

        data = JSON.parse(data)
        if(data.error==0){
            //如果服务器没有返回错误
<<<<<<< HEAD
            var reg = /\[img=\d+,\d+\][^\[]+/
=======
            var reg = /\[img=\d+,\d+\][^\[]+\[\/img\]/g
>>>>>>> dev_AfterTheRainOfStars
            var content = data.article.content

            var pos = 0
            var imgs = content.match(reg)
<<<<<<< HEAD

            for(var i in imgs){
                var img_pos = content.indexOf(imgs[i])
                if(img_pos==-1)
                    return
                var text = content.substring(pos, img_pos)
                mymodel.append({
                            "contentComponent": componentText,
                            "contentData": text
                            })

                var img_url = imgs[i].substring(13, imgs[i].length)

                mymodel.append({
                            "contentComponent": componentImage,
                            "contentData": img_url
                            })
                pos = img_pos+imgs[i].length
=======
            if(imgs){
                for(var i=0; i<imgs.length; ++i){
                    var img_pos = content.indexOf(imgs[i])
                    var text = content.substring(pos, img_pos)

                    mymodel.append({
                                "contentComponent": componentText,
                                "contentData": text
                                })
                    var img_url = imgs[i].substring(13, imgs[i].length-6)

                    mymodel.append({
                                "contentComponent": componentImage,
                                "contentData": img_url
                                })
                    pos = img_pos+imgs[i].length
                }
>>>>>>> dev_AfterTheRainOfStars
            }

            var text = content.substring(pos, content.length)

            if(text!=""){
                mymodel.append({
                            "contentComponent": componentText,
                            "contentData": text
                            })
            }
        }
    }

    onNewsIdChanged: {
        utility.httpGet(getNewsFinished, Api.getNewsContentUrlById(newsId))
        //去获取新闻内容
    }
    onActivePageChanged: {//如果页面是否活跃的状态改变
        if(activePage&&newsTitle!=""){
            textTitle.text = newsTitle
            titleAnimation.start()
        }
    }

    Item{
        id: titleItems

        y:-height
        width: parent.width-20
        height: textTitle.implicitHeight+20
        anchors.horizontalCenter: parent.horizontalCenter

        Text{
            id: textTitle

            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.WordWrap
            color: command.invertedTheme?"black":"#ccc"
            font.pointSize: command.newsTitleFontSize
            font.bold: true
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
        spacing: 10

        model: ListModel{
            id: mymodel
        }
        delegate: newsContentListDelegate
    }

    Component{
        id: newsContentListDelegate

        Loader{
            id: loaderNewsContent

            property string componentData: contentData

            width: parent.width
            opacity: 0
            sourceComponent: contentComponent

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

        Text{
            width: parent.width
            wrapMode: Text.WordWrap
            text: command.textToHtml(componentData, width)
            font.pointSize: command.newsContentFontSize
        }
    }

    Component{
        id: componentImage

        Image{
            source: componentData
            width: Math.min(parent.width, sourceSize.width)
            height: width/sourceSize.width*sourceSize.height
            anchors.horizontalCenter: parent.horizontalCenter
            smooth: true

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    main.showToolBar=false
                    //先关闭状态栏的显示
                    var obj = Qt.createComponent("ImagesBrowse .qml")
                    imagesBrowse = obj.createObject(root)
                    imagesBrowse.imageUrl = parent.source
                    imagesBrowse.opacity = 1
                }
            }
        }
    }

    Connections{
        target: imagesBrowse
        onClose:{
            imagesBrowse.destroy()
            //销毁此控件
            imagesBrowse = null
            main.showToolBar=true
        }
    }
}
