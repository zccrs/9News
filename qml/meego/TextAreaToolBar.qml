// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.star.widgets 1.0
import "./customwidget"

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

    onHeightChanged: {
        parent.height = height
        main.pageStack.toolBar.height = height
        //设置状态栏的高度
    }
    onLeftButtonClick: {
        parent.height = toolBarHeight
        main.pageStack.toolBar.height = toolBarHeight
        //还原状态栏的高度
    }

    Image{
        id:backg

        opacity: command.style.toolBarOpacity
        anchors.fill: parent
        source: command.style.toolBarBackgroundImage
    }

    MyToolIcon{
        id: leftButton

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        iconId: "toolbar-back"


        onClicked: {
            leftButtonClick()
        }
    }
    MyTextArea{
        id: contentField

        placeholderText: qsTr("Plase input text")
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: rightButton.left
        anchors.left: leftButton.right
        anchors.margins: 10
    }
    MyToolIcon{
        id:rightButton

        anchors.right: parent.right
        anchors.bottom: parent.bottom

        onClicked: {
            rightButtonClick()
        }
    }

    Component.onCompleted: {
        contentField.forceActiveFocus()
    }
}
