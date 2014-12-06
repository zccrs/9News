// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    id: root

    property variant loadingImage

    width: parent.width
    height: 160
    clip: true

    function updateFlipcharts(covers){//增加大海报
        if(loadingImage)
            loadingImage.destroy()

        if(typeof covers!="object"){
            root.height = 0
            timerFlipchart.stop()
        }else{
            root.height = 160
        }

        mymodel.clear()
        //先清除数据
        for(var i in covers){
            mymodel.append({"imageUrl": covers[i].thumb, "title": covers[i].topic})
        }
        timerFlipchart.start()
    }

    Behavior on height {
        NumberAnimation { duration: 200 }
    }

    Component{
        id: componentImage

        Image{
            anchors.centerIn: parent
            source: "qrc:/images/loading.png"
        }
    }

    Component.onCompleted: {
        loadingImage = componentImage.createObject(root)
    }

    ListView{
        id: slideList

        anchors.fill:parent
        orientation: ListView.Horizontal
        snapMode :ListView.SnapOneItem
        boundsBehavior: Flickable.StopAtBounds

        model: ListModel{
            id:mymodel
        }
        delegate: Image {
            sourceSize.width: root.width
            source: imageUrl

            MouseArea{
                id: mouse
                anchors.fill: parent
                enabled: false
            }
            Rectangle{
                anchors.bottom: parent.bottom
                width: parent.width
                height: 30
                color: "white"
                opacity: 0.8
                clip: true
                Text{
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    font.pointSize: 3
                    anchors.verticalCenter: parent.verticalCenter
                    text: title
                }
                Text{
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    font.pointSize: 3
                    text: (index+1)+"/"+slideList.count
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

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

            interval: 500

            onTriggered: {
                var temp = slideList.contentX/slideList.width
                number = (temp+1)%slideList.count
                slideList.positionViewAtIndex(number,ListView.Beginning)
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
