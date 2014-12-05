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
    property alias currentPage: pageList.currentItem
    property alias currentPageIndex: pageList.currentIndex
    property alias titleSpacing: titleBarList.spacing

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
        titleBarList.positionViewAtIndex(index, ListView.Contain)
        pageList.currentIndex = index
    }

    function setTitle(index, title){
        titleModel.get(index).title = title
    }
    function getTitle(index){
        return titleModel.get(index).title
    }

    ListView{
        id: titleBarList

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        interactive: false
        orientation: ListView.Horizontal
        snapMode :ListView.SnapOneItem

        delegate: TitleListCompoent{}
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

        model: ListModel{
            id: pageModel
        }

        onFlickEnded: {
            activation(contentX/width)
        }
    }
}
