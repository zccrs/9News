// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import "../utility"
import "customwidget"

MyPage{
    id: root

    property string newsId
    property string newsTitle

    tools: ToolBarSwitch{
        id: toolBarSwitch

        toolBarComponent: compoentToolBarLayout
    }

    onStatusChanged: {
        if(status===PageStatus.Active)
            newsPage.newsTitle = newsTitle
    }

    HeaderView{
        id: headerView

        height: newsPage.titleHeight
    }

    Component{
        id: compoentToolBarLayout

        MyToolBarLayout{
            invertedTheme: command.style.toolBarInverted

            ToolButton{
                iconSource: "toolbar-back"
                platformInverted: command.style.toolBarInverted
                onClicked: {
                    pageStack.pop()
                }
            }

            ToolButton{
                iconSource: command.getIconSource(platformInverted, "edit")
                platformInverted: command.style.toolBarInverted
                onClicked: {
                    toolBarSwitch.toolBarComponent = compoentCommentToolBar
                }
            }

            ToolButton{
                iconSource: command.getIconSource(platformInverted, "comment")
                platformInverted: command.style.toolBarInverted
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("./comment/CommentPage.qml"),
                                   {"newsId": newsId})
                }
            }

            ToolButton{
                iconSource: "toolbar-menu"
                platformInverted: command.style.toolBarInverted
                onClicked: {
                    mainMenu.open()
                }
            }
        }
    }

    Component{
        id: compoentCommentToolBar

        TextAreaToolBar{
            property string oldText: ""
            //记录上次输入的内容

            invertedTheme: command.style.toolBarInverted

            onLeftButtonClick: {
                toolBarSwitch.toolBarComponent = compoentToolBarLayout
            }
            onRightButtonClick: {
                if(textAreaContent=="")
                    return//如果内容没有变化或者为空则不进行下一步
            }
        }
    }

    ReadNewsPage{
        id: newsPage

        anchors.fill: parent
        newsId: root.newsId
        newsTitle: root.newsTitle

        BusyIndicator {
            id: busyIndicator
            running: visible
            visible: newsPage.isBusy
            anchors.centerIn: parent
            width: 50
            height: 50
        }
        ScrollBar {
            platformInverted: command.style.scrollBarInverted
            flickableItem: newsPage.contentList
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                topMargin: newsPage.titleHeight
            }
        }
    }

    Menu {
        id: mainMenu
        // define the items in the menu and corresponding actions
        platformInverted: command.style.menuInverted
        content: MenuLayout {
            MenuItem {
                text: qsTr("Use open browser")
                platformInverted: mainMenu.platformInverted

                ToolButton{
                    text: "Copy url"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    platformInverted: mainMenu.platformInverted

                }

                onClicked: {

                }
            }
            MenuItem {
                text: qsTr("Like")
                platformInverted: mainMenu.platformInverted

                onClicked: {

                }
            }
        }
    }
}
