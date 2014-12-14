// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.star.widgets 1.0

Item{
    id:image_zoom

    property url imageUrl;
    property alias currentImage: imagePreview

    signal close
    signal saveImage

    opacity: 0
    anchors.fill: parent

    onOpacityChanged: {
        if(opacity===1)
            save.visible=true
    }

    Behavior on opacity{
        NumberAnimation{duration: 100}
    }

    Timer{
        id: timerClose
        interval: 100
        onTriggered: {
            close()
        }
    }

    Rectangle{
        anchors.fill: parent
        color: "black"
        opacity: 0.8
    }
    Flickable {
        id: imageFlickable
        width: parent.width
        height: parent.height
        interactive: image_zoom.opacity
        contentWidth: imageContainer.width;
        contentHeight: imageContainer.height

        onHeightChanged: if (imagePreview.status === Image.Ready) imagePreview.fitToScreen()

        Item {

            id: imageContainer
            width: Math.max(imagePreview.width * imagePreview.scale, imageFlickable.width)
            height: Math.max(imagePreview.height * imagePreview.scale, imageFlickable.height)

            MyImage {
                id: imagePreview
                property real prevScale

                anchors.centerIn: parent
                //fillMode: Image.PreserveAspectFit
                //asynchronous: true
                source: imageUrl
                smooth: true

                function fitToScreen() {
                    scale = Math.min(imageFlickable.width / width, imageFlickable.height / height, 1)
                    //pinchArea.minScale = scale
                    prevScale = scale
                }

                onStatusChanged: {
                    if (status == Image.Ready) {
                        fitToScreen()
                        loadedAnimation.start()
                    }
                }

                onScaleChanged: {
                    if ((width * scale) > imageFlickable.width) {
                        var xoff = (imageFlickable.width / 2 + imageFlickable.contentX) * scale / prevScale;
                        imageFlickable.contentX = xoff - imageFlickable.width / 2
                    }
                    if ((height * scale) > imageFlickable.height) {
                        var yoff = (imageFlickable.height / 2 + imageFlickable.contentY) * scale / prevScale;
                        imageFlickable.contentY = yoff - imageFlickable.height / 2
                    }
                    prevScale = scale
                }

                NumberAnimation {
                    id: loadedAnimation

                    target: imagePreview
                    property: "opacity"
                    duration: 250
                    from: 0; to: 1
                    easing.type: Easing.InOutQuad
                }
            }
        }

        PinchArea {
            id: pinchArea

            property real minScale: 0.5//最小比例
            property real maxScale: 3.0//最大比例

            anchors.fill: parent
            enabled: imagePreview.status === Image.Ready
            pinch.target: imagePreview
            pinch.minimumScale: minScale * 0.5 // This is to create "bounce back effect"
            pinch.maximumScale: maxScale * 1.5 // when over zoomed

            onPinchFinished: {
                imageFlickable.returnToBounds()
                if (imagePreview.scale < pinchArea.minScale) {
                    bounceBackAnimation.to = pinchArea.minScale
                    bounceBackAnimation.start()
                }
                else if (imagePreview.scale > pinchArea.maxScale) {
                    bounceBackAnimation.to = pinchArea.maxScale
                    bounceBackAnimation.start()
                }
            }

            NumberAnimation {
                id: bounceBackAnimation
                target: imagePreview
                duration: 250
                property: "scale"
                from: imagePreview.scale
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                image_zoom.opacity = 0
                timerClose.start()
            }
        }
        MouseArea {
            id: mouseArea
            width: imagePreview.width* imagePreview.scale
            height: imagePreview.height*imagePreview.scale
            y:parent.height/2-height/2+imageFlickable.contentY
            x:parent.width/2-width/2+imageFlickable.contentX
            enabled: imagePreview.status === Image.Ready

            onDoubleClicked: {
                //utility.consoleLog("图片的比例："+Math.ceil(imagePreview.scale)+" "+Math.ceil(Math.min(imageFlickable.width / imagePreview.width, imageFlickable.height / imagePreview.height,1)))
                if (Math.ceil(imagePreview.scale) != Math.ceil(Math.min(imageFlickable.width / imagePreview.width, imageFlickable.height / imagePreview.height,1))){
                    bounceBackAnimation.to = Math.min(imageFlickable.width / imagePreview.width, imageFlickable.height / imagePreview.height,1)
                    bounceBackAnimation.start()
                } else if(imagePreview.scale<Math.min(imageFlickable.width / imagePreview.width, imageFlickable.height / imagePreview.height,1))
                {
                    bounceBackAnimation.to = Math.min(imageFlickable.width / imagePreview.width, imageFlickable.height / imagePreview.height,1)
                    bounceBackAnimation.start()
                }
                else{
                    bounceBackAnimation.to = pinchArea.maxScale
                    bounceBackAnimation.start()
                }
            }
            onClicked: {
                if(save.opacity===1)
                    save.opacity=0
                else
                    save.opacity=1
            }
        }

        Connections{
            target: imagePreview
            onScaleChanged:{
                save.opacity=0           ///
            }                                        ///
        }                                            ///
        Connections{                                 ///图片移动或者缩放时停止计时
            target: imageFlickable                ///
            onMovementStarted:{                           ///
                save.opacity=0           ///
            }
        }
    }

    Image{
        id:save
        z:1
        anchors.bottom: parent.bottom
        anchors.bottomMargin:10
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/images/shadow.png"

        Behavior on opacity{
            NumberAnimation{
                duration: 200
            }
        }
        Image{
            source: "qrc:/images/save.svg"
            anchors.centerIn: parent
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                saveImage()
            }
        }
    }
}
