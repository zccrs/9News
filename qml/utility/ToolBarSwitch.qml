// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
//当一个Page需要多个toolBar进行切换时使用此控件来管理
import QtQuick 1.1

Item{
    id: root

    property Component toolBarComponent
    property bool enableAnimation: true

    width: parent?parent.width:screen.width
    height: Math.max(qtObject.currentItem.height, parent.height)
    y: parent?parent.height-height:0

    onToolBarComponentChanged: {
        if(enableAnimation&&qtObject.currentItem){
            timerHide.start()
        }else{
            qtObject.beginSwitch()
        }
    }

    QtObject{
        id: qtObject
        property Item currentItem

        function beginSwitch(){
            if(qtObject.currentItem){
                qtObject.currentItem.destroy()
            }
            if(toolBarComponent){
                qtObject.currentItem = toolBarComponent.createObject(root)
                qtObject.currentItem.visible = true
            }
        }
    }

    Timer{
        id: timerHide

        interval: 200
        onRunningChanged: {
            if(running){
                main.showToolBar = false
            }else{
                qtObject.beginSwitch()
                main.showToolBar = true
            }
        }
    }
}
