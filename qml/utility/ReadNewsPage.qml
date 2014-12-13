// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.star.utility 1.0
import com.star.widgets 1.0
import "../js/api.js" as Api

Item{
    id: root

    property int newsId: -1
    //记录新闻id
    property alias newsTitle: textTitle.text
    //记录新闻标题
    property alias titleHeight: titleItems.height
    //记录新闻标题的高度
    property alias contentList: newsContentList
    //指向新闻内容List
    property Item imagesBrowse
    //指向图片浏览器
    property bool isBusy: false
    //记录是否忙碌，如正在加载新闻内容

    function getNewsFinished(error, data){
        isBusy = false
        //取消忙碌状态

        //获取新闻内容完成
        if(error){
            return
            //如果网络请求过程中出错了就直接return
        }

        data = JSON.parse(data)
        if(data.error==0){
            //如果服务器没有返回错误
            var reg = /\[img=\d+,\d+\][^\[]+\[\/img\]/g
            var content = data.article.content

            var pos = 0
            var imgs = content.match(reg)
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
        isBusy = true
        //设置正在忙碌
        utility.httpGet(getNewsFinished, Api.getNewsContentUrlById(newsId))
        //去获取新闻内容
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

            onTextChanged: {
                titleAnimation.start()
            }
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
            width: newsContentList.width
            wrapMode: Text.WordWrap
            text: componentData
            font.pointSize: command.newsContentFontSize
        }
    }

    Component{
        id: componentImage

        MyImage{
            source: "qrc:/images/loading.png"
            width: Math.min(newsContentList.width, defaultSize.width)
            height: width/defaultSize.width*defaultSize.height
            x: newsContentList.width/2-width/2
            smooth: true
            onLoadReady: {
                if(source!="qrc:/images/loading.png"){
                    mouse.enabled = true
                }
            }


            MouseArea{
                id: mouse
                anchors.fill: parent
                enabled: false
                onClicked: {
                    main.showToolBar=false
                    //先关闭状态栏的显示
                    var obj = Qt.createComponent("ImagesBrowse .qml")
                    imagesBrowse = obj.createObject(root)
                    imagesBrowse.imageUrl = parent.source
                    imagesBrowse.opacity = 1
                }
            }

            Component.onCompleted: {
                source = componentData
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
