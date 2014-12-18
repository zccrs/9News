// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import "../utility"

MyPage{
    id: root

    tools: CustomToolBarLayout{
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
        title: qsTr("about")
        height: screen.currentOrientation===Screen.Portrait?
                     privateStyle.tabBarHeightPortrait:privateStyle.tabBarHeightLandscape
    }

    Flickable{
        id: webviewFlickable

        clip: true
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        maximumFlickVelocity: 3000
        pressDelay:200
        flickableDirection:Flickable.VerticalFlick
        contentHeight: textAbout.implicitHeight

        Text{
            id: textAbout

            property url fileName: "../js/about.html"

            width: parent.width-20
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WordWrap
            text: command.readFile(fileName)

            onLinkActivated: {
                Qt.openUrlExternally(link)
            }
        }
    }
}
