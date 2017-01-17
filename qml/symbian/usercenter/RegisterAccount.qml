// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import QtWebKit 1.0
import "../../js/api.js" as Api
import "../"
import "../customwidget"
import "../../utility"
import "../../js/server.js" as Server

MyPage{

    tools: MyToolBarLayout{
        invertedTheme: command.style.toolBarInverted

        ToolButton{
            iconSource: "toolbar-back"
            platformInverted: command.style.toolBarInverted
            onClicked: {
                pageStack.pop()
            }
        }
    }

    HeaderView{
        id: header

        textColor: command.style.newsContentFontColor
        font.pixelSize: command.style.metroTitleFontPixelSize
        title: qsTr("Register accout")
        height: screen.currentOrientation===Screen.Portrait?
                     privateStyle.tabBarHeightPortrait:privateStyle.tabBarHeightLandscape
    }

    Image{
        id: imageLogo

        source: "qrc:/images/logo.svg"
        width: 100
        height: width
        sourceSize.width: width
        anchors.top: header.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
    }

    TextField{
        id: input_email

        placeholderText: qsTr("Email")
        anchors.top: imageLogo.bottom
        anchors.topMargin: 20
        platformInverted: command.style.textInputInverted
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width*0.8
        KeyNavigation.down: input_nickname
        KeyNavigation.up: input_password2
        KeyNavigation.tab: input_nickname
    }
    TextField{
        id:input_nickname

        placeholderText: qsTr("Nickname")
        platformInverted: command.style.textInputInverted
        anchors {
            top: input_email.bottom
            topMargin: 10
            left: input_email.left
            right: input_email.right
            rightMargin: 10
        }

        KeyNavigation.down: input_password1
        KeyNavigation.up:input_email
        KeyNavigation.tab: input_password1
    }

    TextField{
        id:input_password1

        placeholderText: qsTr("Password")
        platformInverted: command.style.textInputInverted
        anchors {
            top: input_nickname.bottom
            topMargin: 10
            left: input_email.left
            right: input_email.right
            rightMargin: 10
        }
        KeyNavigation.down: input_password2
        KeyNavigation.up:input_nickname
        KeyNavigation.tab: input_password2
        echoMode: TextInput.Password
    }

    TextField{
        id:input_password2

        placeholderText: qsTr("Confirm Password")
        platformInverted: command.style.textInputInverted
        anchors {
            top: input_password1.bottom
            topMargin: 10
            left: input_email.left
            right: input_email.right
            rightMargin: 10
        }
        KeyNavigation.down: input_email
        KeyNavigation.up:input_password1
        KeyNavigation.tab: input_email
        echoMode: TextInput.Password
    }

    Button{
        id: register_button
        enabled: input_email.text &&
                 input_nickname.text &&
                 input_password1.text &&
                 input_password2.text &&
                 (input_password1.text === input_password2.text)
        text: qsTr("Submit")
        font.pixelSize: 18
        anchors.top: input_password2.bottom
        anchors.topMargin: 20

        width: parent.width*0.6
        platformInverted: command.style.textInputInverted
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
            function onRegisterFinished(error, data) {
                if (error) {//如果网络请求出错
                    command.showBanner(qsTr("Network error, will try again."))
                    return
                }

                data = JSON.parse(utility.fromUtf8(data));

                if (data.error) {
                    command.showBanner(data.error);
                    return
                }

                Server.setUserData(data.uid, data.auth);
                command.showBanner(data.message);
                pageStack.replace(Qt.resolvedUrl("UserCenterPage.qml"), {"uid": Server.userData.uid});
            }

            Server.register(input_email.text, input_nickname.text,
                            input_password1.text, input_password2.text,
                            onRegisterFinished);
        }
    }
}
