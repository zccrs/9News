// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import com.star.widgets 1.0

Item{
    id:comment

    property bool invertedTheme: false
    property int toolBarHeight: screen.width < screen.height?
                                    privateStyle.toolBarHeightPortrait:
                                    privateStyle.toolBarHeightLandscape
    property alias leftButtonIconSource: leftButton.iconSource
    property alias rightButtonIconSource: rightButton.iconSource
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

    ToolButton{
        id: leftButton

        anchors.left: parent.left
        anchors.leftMargin: parent.width===640?20:0
        anchors.bottom: parent.bottom
        platformInverted: invertedTheme
        iconSource: "toolbar-back"

        onClicked: {
            leftButtonClick()
        }
    }
    TextArea{
        id: contentField

        platformInverted: invertedTheme
        placeholderText: "请输入评论内容"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: rightButton.left
        anchors.left: leftButton.right
        anchors.margins: 10

    }
    ToolButton{
        id:rightButton

        anchors.right: parent.right
        anchors.rightMargin: parent.width===640?20:0
        anchors.bottom: parent.bottom
        platformInverted: invertedTheme
        iconSource: command.getIconSource(invertedTheme, "message_send", "svg", true)

        onClicked: {
            rightButtonClick()
        }
    }

    Component.onCompleted: {
        contentField.forceActiveFocus()
        contentField.openSoftwareInputPanel()
    }
}
