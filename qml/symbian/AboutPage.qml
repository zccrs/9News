// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtWebKit 1.0
import com.nokia.symbian 1.1
import "../utility"

MyPage{
    id: root

    tools: CustomToolBarLayout{
        invertedTheme: command.invertedTheme

        ToolButton{
            iconSource: "toolbar-back"
            platformInverted: command.invertedTheme
            onClicked: {
                pageStack.pop()
            }
        }
    }

    HeaderView{
        id: header
        invertedTheme: command.invertedTheme
        font.pointSize: command.style.metroTitleFontPointSize
        title: qsTr("about")
        height: screen.currentOrientation===Screen.Portrait?
                     privateStyle.tabBarHeightPortrait:privateStyle.tabBarHeightLandscape
    }

    Flickable{
        id:aboutFlick
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        clip: true
        maximumFlickVelocity: 3000
        pressDelay:200
        flickableDirection:Flickable.VerticalFlick
        contentHeight: myhtml.height

        WebView{
            id:myhtml
            width: parent.width
            preferredWidth: width
            settings{
                javascriptEnabled: true
            }

            anchors.verticalCenter: parent.verticalCenter
            url:"../js/about.html"
            javaScriptWindowObjects: QtObject {
                WebView.windowObjectName: "qml"
                function openUrl(src){
                    Qt.openUrlExternally(src)
                }
            }

            function setHtmlTheme(inverted){
                var color = inverted?"#f1f1f1":"#000"
                myhtml.evaluateJavaScript('document.body.style.setProperty("background-color","'+color+'");')
                var font_color = inverted?"#000":"#888"
                myhtml.evaluateJavaScript('document.body.style.setProperty("color","'+font_color+'");')
            }
            function setBodyWidth(width){
                myhtml.evaluateJavaScript('document.body.style.setProperty("width", "'+String(width)+'");')
            }

            onLoadFinished: {
                setHtmlTheme(command.invertedTheme)
                setBodyWidth(width-20)
            }
        }
    }
}
