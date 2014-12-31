// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import QtWebKit 1.0
import "../../js/api.js" as Api
import "../"
import "../customwidget"
import "../../utility"

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

        placeholderText: qsTr("email")
        anchors.top: imageLogo.bottom
        anchors.topMargin: 20
        platformInverted: command.style.textInputInverted
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width*0.8
        KeyNavigation.down: input_code
        KeyNavigation.up: input_code
        KeyNavigation.tab: input_code
    }
    TextField{
        id:input_code

        placeholderText: qsTr("code")
        platformInverted: command.style.textInputInverted
        anchors.top: input_email.bottom
        anchors.topMargin: 10
        anchors.left: input_email.left
        anchors.right: code_image.left
        anchors.rightMargin: 10
        KeyNavigation.down: input_email
        KeyNavigation.up:input_email
        KeyNavigation.tab: input_email
    }

    Image{
        id:code_image

        cache: false
        width: sourceSize.width
        anchors.right: input_email.right
        anchors.verticalCenter: input_code.verticalCenter

        Behavior on width{
            NumberAnimation{
                duration: 200
            }
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {

            }
        }
    }

    Button{
        id: register_button
        enabled: input_email.text!=""&input_code.text!=""
        text: qsTr("Submit")
        font.pixelSize: 18
        anchors.top: input_code.bottom
        anchors.topMargin: 20

        width: parent.width*0.6
        platformInverted: command.style.textInputInverted
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {

        }
    }
}
