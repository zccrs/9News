// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    id: root

    width: parent.width
    clip: true

    function updateFlipcharts(covers){//增加大海报
        if(typeof covers!="object"){
            root.height = 0
            timerFlipchart.stop()
        }
        //先清除数据
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

    function clearFlipcharts(){
        mymodel.clear()
        root.height = 0
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

    Connections{
        target: componentData//此对象在他的父对象中（NewsList的listDelegate的Loader中）
        onEmitUpdateFlipcharts:{
            updateFlipcharts(covers)
        }
    }

    Component{
        id: compoentPathView
        Item{
            width: parent.width
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
                    font.pointSize: command.style.flipchartsTitleFontPointSize
                    anchors.verticalCenter: parent.verticalCenter
                    text: title
                    elide: Text.ElideRight
                }
                Text{
                    id: newsIndexAndCount
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    font.pointSize: command.style.flipchartsTitleFontPointSize
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

    PathView{
        id: slideList

        anchors.fill:parent

        path:Path{
            startX: -slideList.width*slideList.count/2
            startY: slideList.height/2
            PathLine{
                x: slideList.width*slideList.count/2
                y: slideList.height/2
            }
        }


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

            interval: 400

            onTriggered: {
                var temp = slideList.contentX/slideList.width
                number = (temp+1)%slideList.count
                slideList.incrementCurrentIndex ()
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
}
