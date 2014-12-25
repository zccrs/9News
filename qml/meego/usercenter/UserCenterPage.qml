// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import QtWebKit 1.0
import "../../js/api.js" as Api
import "../"
import "../customwidget"
import "../../utility"

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
            url: Api.loginUrl

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
