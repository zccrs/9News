// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.star.utility 1.0

Item{
    id: root

    property ListView listView
    property bool invertedTheme: false
    property int menuItemPixelSize: 22
    property int currentIndex: listMenu.currentIndex
    property int menuItemHeight: 30
    property alias listModel: mymodel

    signal trigger(int index)

    height: listMenu.count*(menuItemHeight+listMenu.spacing+10)

    function addMenu(menuText, iconSource){
        var obj = {
            "iconSource": iconSource?iconSource:"",
            "menuText": menuText
        }

        mymodel.append(obj)
    }

    function removeMenu(index){
        mymodel.remove(index)
    }

    function clearMenu(){
        mymodel.clear()
    }

    function insertMenu(index, menuText, iconSource){
        var obj = {
            "iconSource": iconSource?iconSource:"",
            "menuText": menuText
        }
        mymodel.insert(index, obj)
    }

    function setMenuText(index, value){
        if(index<mymodel.count)
            mymodel.get(index).menuText = value
    }

    function getMenuText(index){
        return mymodel.get(index).menuText
    }

    ListView{
        id: listMenu

        property int yDeviation: 0

        interactive: false
        width: parent.width
        height: parent.height
        spacing: 5
        clip: true

        onHeightChanged: {
            updateY()
        }

        function updateY(){
            if(listView.atYBeginning){
                y = -listView.contentY+yDeviation-height-10
            }else{
                y = -height
            }
        }

        onYChanged:{
            if(y>height){
                currentIndex = 0
            }else{
                var index = listMenu.indexAt(width/2, root.height-y)
                currentIndex = index
            }
        }

        model: ListModel{
            id: mymodel
        }
        delegate: listDelegate

        Connections{
            target: listView

            onContentYChanged:{
                listMenu.updateY()
            }

            onAtYBeginningChanged:{
                if(listView.atYBeginning){
                    listMenu.yDeviation = listView.contentY
                }
            }
        }
    }

    Component{
        id: listDelegate

            Item{

            property bool active: ListView.view.currentIndex == index

            width: icon.implicitWidth+title.implicitWidth+title.anchors.leftMargin
            height: title.implicitHeight
            anchors.horizontalCenter: parent.horizontalCenter

            Image{
                id: icon
                anchors.verticalCenter: parent.verticalCenter
                sourceSize.height: parent.height-10
                source: iconSource
            }
            Text{
                id: title

                anchors.left: icon.right
                anchors.leftMargin: iconSource!=""?10:0
                text: menuText
                color: active?command.style.metroActiveTitleFontColor:
                               command.style.metroInactiveTitleFontColor
                scale: active?1.2:1

                font{
                    bold: active
                    pixelSize: menuItemPixelSize
                }

                Behavior on scale{
                    NumberAnimation{
                        duration: 300
                    }
                }
            }

            Component.onCompleted: {
                menuItemHeight = height
            }

            onHeightChanged: {
                menuItemHeight = height
            }
        }
    }

    MonitorMouseEvent{
        target: listView
        anchors.fill: parent

        onMouseRelease: {
            if(currentIndex>=0){
                trigger(currentIndex)
            }
        }
    }
}
