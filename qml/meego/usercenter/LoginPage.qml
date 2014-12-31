// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import "../customwidget"
import "../../utility"
import "../../js/api.js" as Api

Page{
    id: root

    tools: MyToolBarLayout{
        MyToolIcon{
            iconId: "toolbar-back"

            onClicked: {
                pageStack.pop()
            }
        }
        MyToolIcon{
            iconId: "toolbar-view-menu"

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
        height: screen.currentOrientation===Screen.Portrait?72:56
    }

    Image{
        id: imageLogo

        source: "qrc:/images/logo.svg"
        width: 150
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
                    width: 60
                    sourceSize.width: 60
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
                    width: 150
                    sourceSize.width: 150
                }
            }
        ]

        transitions: [
            Transition {
                AnchorAnimation{
                    duration: 200
                }
                PropertyAnimation{
                    duration: 200
                    property: "width"
                }
            }
        ]

        Connections{
            target: root.status==PageStatus.Active?inputContext:null
            onSoftwareInputPanelVisibleChanged:{
                if(inputContext.softwareInputPanelVisible){
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
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width*0.8
        KeyNavigation.down: inputPassword
        KeyNavigation.up: buttonLogin
        KeyNavigation.tab: inputPassword
    }
    TextField{
        id: inputPassword

        placeholderText: qsTr("password")
        anchors.top: inputEmail.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width*0.8
        KeyNavigation.down: buttonLogin
        KeyNavigation.up: inputEmail
        KeyNavigation.tab: buttonLogin
        echoMode: TextInput.Password
    }

    MyButton{
        id: buttonLogin

        enabled: inputEmail.text!=""&&inputPassword.text!=""
        text: qsTr("Login")
        font.pixelSize: 18
        anchors.top: inputPassword.bottom
        anchors.topMargin: 20
        width: parent.width*0.6
        anchors.horizontalCenter: parent.horizontalCenter
        KeyNavigation.down: inputEmail
        KeyNavigation.up: inputPassword
        KeyNavigation.tab: inputEmail

        onClicked: {

        }
    }

    MyMenu {
        id: mainMenu
        // define the items in the menu and corresponding actions
        content: MenuLayout {
            MyMenuItem {
                text: qsTr("Register account")

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("RegisterAccount.qml"))
                }
            }
            MyMenuItem {
                text: qsTr("Retrieve password")

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("RetrievePassword.qml"))
                }
            }
        }
    }
}
