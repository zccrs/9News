// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import QtWebKit 1.0
import "../../js/api.js" as Api
import "../"
import "../customwidget"
import "../../utility"

MyPage{
    id: root

    tools: MyToolBarLayout{
        invertedTheme: command.style.toolBarInverted

        ToolButton{
            iconSource: "toolbar-back"
            platformInverted: command.style.toolBarInverted
            onClicked: {
                pageStack.pop()
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

    HeaderView{
        id: header

        textColor: command.style.newsContentFontColor
        font.pixelSize: command.style.metroTitleFontPixelSize
        title: qsTr("Login")
        height: screen.currentOrientation===Screen.Portrait?
                     privateStyle.tabBarHeightPortrait:privateStyle.tabBarHeightLandscape
    }

    Image{
        id: imageLogo

        source: "qrc:/images/logo.svg"
        width: 100
        height: width
        anchors.top: header.bottom
        anchors.topMargin: 10
        state: "notlogin"

        states: [
            State {
                name: "logining"
                AnchorChanges {
                    target: imageLogo
                    anchors.left: inputEmail.left
                }
                PropertyChanges {
                    target: imageLogo
                    width: 50
                    sourceSize.width: 50
                }
            },
            State {
                name: "notlogin"
                AnchorChanges {
                    target: imageLogo
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                PropertyChanges {
                    target: imageLogo
                    width: 100
                    sourceSize.width: 100
                }
            }
        ]

        transitions: [
            Transition {
                AnchorAnimation{
                    duration: 300
                }
                PropertyAnimation{
                    duration: 300
                    property: "width"
                }
            }
        ]

        Connections{
            target: inputContext
            onVisibleChanged:{
                if(inputContext.visible){
                    imageLogo.state = "logining"
                }else{
                    timerStateChange.start()
                }
            }
        }

        Timer{
            id: timerStateChange
            interval: 200
            onTriggered: {
                if(!inputContext.visible)
                    imageLogo.state = "notlogin"
            }
        }

        MouseArea{
            anchors.fill: parent

            onClicked: {
                inputEmail.closeSoftwareInputPanel()
            }
        }
    }

    Text{
        id: textLogin

        text: qsTr("Plase login")
        color: command.style.newsContentFontColor
        font.pixelSize: 22
        anchors.left: imageLogo.right
        anchors.leftMargin: 10
        anchors.verticalCenter: imageLogo.verticalCenter
        visible: imageLogo.state == "logining"
    }

    TextField{
        id: inputEmail

        placeholderText: qsTr("email")
        anchors.top: imageLogo.bottom
        anchors.topMargin: 20
        platformInverted: command.style.textInputInverted
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width*0.8
        KeyNavigation.down: inputPassword
        KeyNavigation.up: buttonLogin
        KeyNavigation.tab: inputPassword
    }
    TextField{
        id: inputPassword

        placeholderText: qsTr("password")
        platformInverted: command.style.textInputInverted
        anchors.top: inputEmail.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width*0.8
        KeyNavigation.down: buttonLogin
        KeyNavigation.up: inputEmail
        KeyNavigation.tab: buttonLogin
        echoMode: TextInput.Password
    }

    Button{
        id: buttonLogin

        enabled: inputEmail.text!=""&&inputPassword.text!=""
        text: qsTr("Login")
        font.pixelSize: 18
        anchors.top: inputPassword.bottom
        anchors.topMargin: 20
        width: parent.width*0.6
        platformInverted: command.style.buttonInverted
        anchors.horizontalCenter: parent.horizontalCenter
        KeyNavigation.down: inputEmail
        KeyNavigation.up: inputPassword
        KeyNavigation.tab: inputEmail

        onClicked: {

        }
    }

    Menu {
        id: mainMenu
        // define the items in the menu and corresponding actions
        platformInverted: command.style.menuInverted
        content: MenuLayout {
            MenuItem {
                text: qsTr("Register account")
                platformInverted: mainMenu.platformInverted

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("RegisterAccount.qml"))
                }
            }
            MenuItem {
                text: qsTr("Retrieve password")
                platformInverted: mainMenu.platformInverted

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("RetrievePassword.qml"))
                }
            }
        }
    }
}
