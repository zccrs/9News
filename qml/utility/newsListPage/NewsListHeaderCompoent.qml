// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    id: root

    property bool isBusy: false
    //记录是否是忙碌的，例如正在下载大海报

    width: parent.width
    clip: true

    function loadFlipcharts(){//加载大海报列表
        if(isBusy){
            return
            //如果忙碌就return
        }

        if(covers==null){
            isBusy=true
            //设置为忙碌的
            timerFlipchart.stop()
            //先停止动画
            utility.httpGet(root, "getImagePosterFinished(QVariant,QVariant)", imagePosterUrl)
            return
        }

        for(var i in covers){
            var obj = {
                "imageUrl": covers[i].thumb,
                "title": covers[i].topic,
                "newsId": covers[i].cid
            }
            mymodel.append(obj)
        }
        timerFlipchart.start()
    }

    function getImagePosterFinished(error, data){//下载大海报完毕
        isBusy = false
        //取消忙碌状态

        if(error){
            command.showBanner(qsTr("Flipcharts update failed, will try again."))
            return
        }
        data = JSON.parse(data)

        if(data.error==0){
            parentListModel.setProperty(index, "covers", data.covers)
            loadFlipcharts()
        }else{
            command.showBanner(data.error)
        }
    }

    function show(toHeight){
        if(root.height==toHeight)
            return

        if(enableAnimation){//如果允许动画
            animationHeight.to = toHeight
            animationHeight.start()
        }else{
            root.height = toHeight
        }
    }

    NumberAnimation {
        id: animationHeight
        running: false
        target: root
        duration: 500
        property: "height"
        from: 0
    }

    Component{
        id: compoentPathView
        Item{
            width: root.width
            height: parent.height

            Image {
                sourceSize.width: parent.width
                anchors.centerIn: parent
                source: imageUrl

                onImplicitHeightChanged: {
                    root.show(implicitHeight)
                }
            }

            Rectangle{
                anchors.bottom: parent.bottom
                width: parent.width
                height: 30
                color: "white"
                opacity: 0.8

                Text{
                    anchors.left: parent.left
                    anchors.right: newsIndexAndCount.left
                    anchors.margins: 10
                    font.pixelSize: command.style.flipchartsTitleFontPixelSize
                    anchors.verticalCenter: parent.verticalCenter
                    text: title
                    elide: Text.ElideRight
                }
                Text{
                    id: newsIndexAndCount
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    font.pixelSize: command.style.flipchartsTitleFontPixelSize
                    text: (index+1)+"/"+slideList.count
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea{
                anchors.fill: parent

                onClicked: {
                    command.getNews(newsId, title)
                }
            }
        }
    }

    ListView{
        id: slideList

        anchors.fill: parent
        orientation: ListView.Horizontal
        snapMode :ListView.SnapOneItem

        model: ListModel{
            id:mymodel
        }
        delegate: compoentPathView

        onMovementStarted: {
            timerFlipchart.stop()
        }
        onMovementEnded: {
            timerFlipchart.start()
        }
    }

    Flipable{
        id: slideFlipable

        property bool flipable: false

        anchors.fill: parent
        state: "front"
        front: slideList

        function flipableBegin(){
            if(state == "front" )
                state = "back"
            else
                state = "front"
            timerSetListCurrentPage.start()
            slideList.interactive = false
        }
        Timer{
            id: timerFlipchart
            interval: 9000
            repeat: true
            onTriggered: slideFlipable.flipableBegin()
        }
        Timer{
            id: timerSetListCurrentPage

            property int number: 0//记录改翻转到第几个大海报

            interval: 300

            onTriggered: {
                var temp = slideList.contentX/slideList.width
                number = (temp+1)%slideList.count
                slideList.positionViewAtIndex(number, ListView.Beginning)
                slideList.interactive = true
            }
        }

        transform: Rotation {
            id: rotation
            origin.x: slideFlipable.width/2
            origin.y: slideFlipable.height/2
            axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
            angle: 0    // the default angle
        }

        states: [
            State {
                name: "back"
                PropertyChanges { target: rotation; angle: 360 }
            },
            State {
                name: "front"
                PropertyChanges { target: rotation; angle: 0 }
            }
        ]
        transitions: Transition {
            NumberAnimation {
                target: rotation;
                property: "angle";
                duration: 1000
                easing.type: Easing.InOutBack
            }
        }
    }

    Component.onCompleted: {
        loadFlipcharts()//加载大海报
    }
}
