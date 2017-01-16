// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import "../utility"
import "./customwidget"
import "../js/server.js" as Server

MyPage{
    id: root

    property int string
    property string newsTitle

    tools: ToolBarSwitch{
        id: toolBarSwitch

        toolBarComponent: compoentToolBarLayout
    }

    HeaderView{
        id: headerView

        height: newsPage.titleHeight
    }

    Component{
        id: compoentToolBarLayout

        MyToolBarLayout{
            MyToolIcon{
                iconId: "toolbar-back"
                onClicked: {
                    pageStack.pop()
                }
            }

            MyToolIcon{
                iconId: "toolbar-edit"
                onClicked: {
                    toolBarSwitch.toolBarComponent = compoentCommentToolBar
                }
            }

            MyToolIcon{
                iconSource: command.getIconSource(command.style.toolBarInverted, "comment")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("./comment/CommentPage.qml"),
                                   {"newsId": newsId})
                }
            }

            MyToolIcon{
                iconId: "toolbar-view-menu"

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
            rightButtonIconSource: command.getIconSource(invertedTheme, "message_send", "svg", true)

            onLeftButtonClick: {
                toolBarSwitch.toolBarComponent = compoentToolBarLayout
            }
            onRightButtonClick: {
                if (!textAreaContent)
                    return//如果内容没有变化或者为空则不进行下一步

                if (!Server.userData.auth) {
                    command.showBanner(qsTr("You are not logged in"));
                    return;
                }

                function onCommentFinished(error, data) {
                    if (error) {
                        command.showBanner(qsTr("Network error, Will try again."));
                        return;
                    }

                    data = JSON.parse(utility.fromUtf8(data))

                    if (data.error) {
                        command.showBanner(data.error);
                        return;
                    }

                    command.showBanner(data.message);
                }

                Server.sendComment(newsId, textAreaContent, "Test By zccrs", onCommentFinished);
            }
        }
    }

    ReadNewsPage{
        id: newsPage
        anchors.fill: parent
        newsId: root.newsId
        newsTitle: root.newsTitle

        MyBusyIndicator {
            id: busyIndicator
            running: visible
            visible: newsPage.isBusy
            anchors.centerIn: parent
            width: 100
            height: 100

            platformStyle: BusyIndicatorStyle {
                     period: 800
                     size: "large"
                 }
        }
    }

    MyScrollDecorator {
        flickableItem: newsPage.contentList
    }

    MyMenu {
        id: mainMenu
        // define the items in the menu and corresponding actions
        content: MenuLayout {
            MyMenuItem {
                text: qsTr("Use open browser")
                MyToolButton{
                    text: "Copy url"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    invertedTheme: mainMenu.invertedTheme

                    onClicked: {
                        utility.setClipboardText(Server.getNewsBrowserUrl(newsId));
                        mainMenu.close();
                    }
                }

                onClicked: {
                    Qt.openUrlExternally(Server.getNewsBrowserUrl(newsId))
                }
            }
//            MyMenuItem {
//                text: qsTr("Like")
//                onClicked: {

//                }
//            }
        }
    }
}
