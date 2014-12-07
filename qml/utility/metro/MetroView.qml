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
    property alias pageInteractive: pageList.interactive
    //此属性设置是否可以左右滑动切换page
    property alias titleInteractive: titleBarList.interactive
    //此属性设置是否可以左右滑动和点击标题

    function addPage(title, obj){
        titleModel.append({"title":title})
        obj.parentListModel = pageModel
        pageModel.append(obj)
    }
    function insertPage(index, title, obj){
        titleModel.insert(index, {"title":title})
        obj.parentListModel = pageModel
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

    ListView{
        id: titleBarList
        clip: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        orientation: ListView.Horizontal
        snapMode :ListView.SnapOneItem

        delegate: TitleListCompoent{
            MouseArea{
                enabled: titleBarList.interactive
                anchors.fill: parent
                onClicked: {
                    activation(index)
                }
            }
        }
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
