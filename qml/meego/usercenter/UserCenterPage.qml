// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import QtWebKit 1.0
import com.zccrs.widgets 1.0
import "../../js/api.js" as Api
import "../"
import "../customwidget"
import "../../utility"
import "../../js/server.js" as Server

MyPage{

    tools: MyToolBarLayout{
        MyToolIcon{
            iconId: "toolbar-back"
            onClicked: {
                pageStack.pop()
            }
        }
    }

    HeaderView{
        id: header

        textColor: command.style.newsContentFontColor
        font.pixelSize: command.style.metroTitleFontPixelSize
        title: qsTr("Personal center")
        height: screen.currentOrientation===Screen.Portrait?72:56
    }


    Component.onCompleted: {
        function onGetUserInfoFinished(error, data) {
            if (error) {
                command.showBanner(qsTr("Network error, will try again."))
                return
            }

            data = JSON.parse(utility.fromUtf8(data))

            if (data.error) {
                command.showBanner(data.error);
                return;
            }

            privateData.userInfos = data;
        }

        utility.httpGet(onGetUserInfoFinished, Api.getUserInfoUrl(uid));
    }

    QtObject {
        id: privateData

        property variant userInfos: null
    }

    Column {
        anchors {
            top: header.bottom
            topMargin: 50
            left: parent.left
            right: parent.right
        }

        MaskImage {
            source: privateData.userInfos.member.avatar
            anchors.horizontalCenter: parent.horizontalCenter
            maskSource: "qrc:///images/mask.bmp"
        }

        Item {
            width: 1
            height: 50
        }

        Text {
            color: command.style.newsContentFontColor
            font.pixelSize: 22
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Nickname: ") + privateData.userInfos.member.nickname
        }

        Text {
            color: command.style.newsContentFontColor
            font.pixelSize: 22
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Group: ") + privateData.userInfos.member.group
        }
    }

    MyButton {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 20
        }

        platformInverted: command.style.buttonInverted
        text: qsTr("Logout");

        onClicked: {
            Server.setUserData("", "");
            pageStack.replace(Qt.resolvedUrl("LoginPage.qml"));
        }
    }
}
