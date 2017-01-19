// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import "../../js/api.js" as Api
import "../"
import "../customwidget"
import "../../utility"
import "../../js/server.js" as Server

MyPage{
    id: root

    property string newsId

    tools: ToolBarSwitch{
        id: toolBarSwitch

        toolBarComponent: compoentToolBarLayout
    }

    HeaderView{
        id: header

        textColor: command.style.newsContentFontColor
        font.pixelSize: command.style.metroTitleFontPixelSize
        title: qsTr("Comment")
        height: screen.currentOrientation===Screen.Portrait?72:56
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
                iconId: "toolbar-refresh"
                onClicked: {
                    commentList.refreshComment()
                }
            }

            MyToolIcon{
                iconId: "toolbar-view-menu"

                onClicked: {
                    //mainMenu.open()
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
            placeholderText: commentList.willReplyCommentId ? (qsTr("Reply") + " " + commentList.willReplyUserName)
                                                            : qsTr("Plase input text")
            rightButtonIconSource: command.getIconSource(invertedTheme, "message_send", "svg", true)

            onLeftButtonClick: {
                textArea.closeSoftwareInputPanel()
                toolBarSwitch.toolBarComponent = compoentToolBarLayout

                commentList.willReplyCommentId = "";
                commentList.willReplyUserName = "";
            }
            onRightButtonClick: {
                if (!textAreaContent)
                    return//如果内容没有变化或者为空则不进行下一步

                if (!Server.userData.auth) {
                    command.showBanner(qsTr("Plase login"));
                    pageStack.push(Qt.resolvedUrl("../usercenter/LoginPage.qml"), {"backWhenLoginFinished": true});
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
                    leftButtonClick();
                }

                if (commentList.willReplyCommentId)
                    Server.sendSubComment(commentList.willReplyCommentId, textAreaContent, main.deviceModel, onCommentFinished);
                else
                    Server.sendComment(newsId, textAreaContent, main.deviceModel, onCommentFinished);
            }
        }
    }


    CommentList{
        id: commentList

        property string willReplyCommentId
        property string willReplyUserName

        width: parent.width-20
        anchors{
            horizontalCenter: parent.horizontalCenter
            top: header.bottom
            topMargin: 10
            bottom: parent.bottom
        }
        newsId: root.newsId
        clip: true

        onReplyComment: {
            willReplyCommentId = commentId
            willReplyUserName = targetUserName
            toolBarSwitch.toolBarComponent = compoentCommentToolBar
        }

        onUserAvatarClicked: {
            pageStack.push(Qt.resolvedUrl("../usercenter/UserCenterPage.qml"), {"uid": userId});
        }
    }

    MyBusyIndicator {
        id: busyIndicator

        running: visible
        visible: commentList.isBusy
        anchors.centerIn: parent
        width: 100
        height: 100

        platformStyle: BusyIndicatorStyle{
                 period: 800
                 size: "large"
             }
    }

    MyScrollDecorator {
        flickableItem: commentList.listView
    }
}
