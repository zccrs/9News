// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Image{
    id: root

    property Flickable target
    property int animationDuration: 300

    source: "qrc:/images/up.svg"
    sourceSize.width: width
    visible: target.contentY>0

    Behavior on opacity{
        NumberAnimation{
            duration: animationDuration
        }
    }

    Connections{
        target: root.target

        onMovementStarted:{
            root.opacity = 0
        }
        onMovementEnded:{
            root.opacity = 1
            timer.start()
        }
    }

    Timer{
        id: timer

        interval: 5000
        running: true
        onTriggered: {
            root.opacity = 0.3
        }
    }

    NumberAnimation{
        id: targetAnimation

        running: false
        target: root.target
        property: "contentY"
        duration: animationDuration
        to: 0
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            root.opacity = 1
            targetAnimation.start()
        }
    }
}
