// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.star.utility 1.0

Item{
    id: root

    property ListView listView
    property bool invertedTheme: false
    property int menuItemPointSize: 8
    property int currentIndex: listMenu.currentIndex

    signal trigger(int index)

    height: listMenu.count*(30+listMenu.spacing)

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

        interactive: false
        width: parent.width
        height: parent.height
        spacing: 5

        y:{
            if(listView.contentY<0){
                return -listView.contentY-height-10
            }else{
                return -height
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
    }

    Component{
        id: listDelegate

        Item{

            property bool active: ListView.view.currentIndex == index

            width: icon.implicitWidth+title.width+title.anchors.leftMargin
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
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: icon.right
                anchors.leftMargin: iconSource!=""?10:0
                wrapMode: Text.WordWrap
                text: menuText
                color: active?"black":"#888"
                scale: active?1.2:1

                font{
                    bold: active
                    pointSize: menuItemPointSize
                }

                Behavior on scale{
                    NumberAnimation{
                        duration: 200
                    }
                }
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
