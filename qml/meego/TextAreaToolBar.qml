// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.star.widgets 1.0

Item{
    id:comment

    property bool invertedTheme: false
    property int toolBarHeight: screen.currentOrientation===Screen.Portrait?72:56
    property alias leftButtonIconSource: leftButton.iconSource
    property alias leftButtonIconId: leftButton.iconId
    property alias rightButtonIconSource: rightButton.iconSource
    property alias rightButtonIconId: rightButton.iconId
    property alias textAreaContent: contentField.text
    property alias textArea: contentField

    signal leftButtonClick
    signal rightButtonClick

    clip: true
    visible: false
    width: parent.width
    height: Math.max(toolBarHeight, contentField.height+5)

    Image{
        id:backg

        opacity: command.style.toolBarOpacity
        anchors.fill: parent
        sourceSize.width: width
        source: command.style.toolBarBackgroundImage
    }

    ToolIcon{
        id: leftButton

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        iconId: "toolbar-back"


        onClicked: {
            leftButtonClick()
        }
    }
    TextArea{
        id: contentField

        placeholderText: "请输入评论内容"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: rightButton.left
        anchors.left: leftButton.right
        anchors.margins: 10

        onActiveFocusChanged: {
            if(activeFocus){
                openSoftwareInputPanel()
            }else{
                closeSoftwareInputPanel()
            }
        }
    }
    ToolIcon{
        id:rightButton

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        iconSource: command.getIconSource(invertedTheme, "message_send", "svg", true)

        onClicked: {
            rightButtonClick()
        }
    }

    Component.onCompleted: {
        contentField.forceActiveFocus()
        contentField.openSoftwareInputPanel()
        console.log(command.getIconSource(invertedTheme, "message_send", "svg", true))
    }
}
