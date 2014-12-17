/*
  *模仿微软的Metro的左右滑动页面设计
  *MetroView为管理MetroPage的视图
  *为每一个Page在顶端显示一个标题。
  *左右滑动来切换Page。
  *定义了增加Page，移除Page的方法
*/
// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    id: rootView

    property alias delegate: pageList.delegate
    property alias titleBarHeight: titleBarList.height
    property alias pageCount: pageList.count
    //property alias currentPage: pageList.currentItem
    property alias currentPageIndex: pageList.currentIndex
    property alias titleSpacing: titleBarList.spacing
    property bool pageInteractive: true
    //此属性设置是否可以左右滑动切换page
    property alias titleInteractive: titleBarList.interactive
    //此属性设置是否可以左右滑动和点击标题
    property int titleMaxFontSize: 7

    function addPage(title, obj){
        titleModel.append({"title":title})
        pageModel.append(obj)
    }
    function insertPage(index, title, obj){
        titleModel.insert(index, {"title":title})
        pageModel.insert(index, obj)
    }
    function removePage(index){
        titleModel.remove(index)
        pageModel.remove(index)
    }
    function clearPage(){
        titleModel.clear()
        pageModel.clear()
    }
    function activation(index){
        titleBarList.currentIndex = index
        titleBarList.positionViewAtIndex(index, ListView.Beginning)
        pageList.currentIndex = index
        pageList.positionViewAtIndex(index, ListView.Beginning)
    }

    function setTitle(index, title){
        titleModel.get(index).title = title
    }
    function getTitle(index){
        return titleModel.get(index).title
    }
    function setProperty(index, name, value){
        if(index<pageModel.count)
        pageModel.setProperty(index, name, value)
    }

    ListView{
        id: titleBarList

        clip: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        orientation: ListView.Horizontal
        snapMode :ListView.SnapOneItem
        interactive: pageInteractive

        delegate: titleListDelegate
        model: ListModel{
            id: titleModel
        }
    }

    ListView{
        id: pageList
        clip: true
        width: parent.width
        anchors.top: titleBarList.bottom
        anchors.bottom: parent.bottom
        orientation: ListView.Horizontal
        snapMode :ListView.SnapOneItem
        boundsBehavior: Flickable.StopAtBounds
        interactive: pageInteractive

        model: ListModel{
            id: pageModel
        }

        onFlickEnded: {
            activation(contentX/width)
        }
    }

    Component{
        id: titleListDelegate

        Text{
            id: root

            text: title
            anchors.verticalCenter: parent.verticalCenter
            opacity: 1-Math.abs(ListView.view.currentIndex-index)/10
            font.pixelSize: titleMaxFontSize
            color: {
                if(ListView.isCurrentItem){
                    return command.style.metroActiveTitleFontColor
                }else{
                    return command.style.metroInactiveTitleFontColor
                }
            }

            font{
                bold: ListView.isCurrentItem
            }

            scale:{
                var deviations = Math.abs(ListView.view.currentIndex-index)
                if(deviations<4)
                    return 1-deviations/5
                else
                    return 0.4
            }

            Behavior on scale{
                NumberAnimation{
                    duration: 300
                }
            }

            MouseArea{
                enabled: titleBarList.interactive
                anchors.fill: parent
                onClicked: {
                    activation(index)
                }
            }
            Component.onCompleted: {
                if(implicitHeight>titleBarList.implicitHeight-10){
                    titleBarList.implicitHeight = implicitHeight+20
                }
            }
        }
    }
}
