// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.yeatse.widgets 1.0
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

        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        maximumFlickVelocity: 3000
        pressDelay:200
        flickableDirection:Flickable.VerticalFlick
        contentHeight: myhtml.contentsSize.height

        onContentYChanged: {
            myhtml.setScrollPosition(Qt.point(0, contentY))
        }
    }

    WebView{
        id:myhtml

        z: -1
        enabled: false
        anchors.fill: webviewFlickable
        anchors.topMargin: -20

        /*settings{
            javascriptEnabled: true
        }*/

        url: "../js/about.html"
        /*javaScriptWindowObjects: QtObject {
            WebView.windowObjectName: "qml"
            function openUrl(src){
                Qt.openUrlExternally(src)
            }
        }*/
        function setBodyProperty(name, value){
            myhtml.evaluateJavaScript('document.body.style.setProperty("'+name+'","'+value+'");')
        }

        function setHtmlTheme(){
            var image_url = command.style.backgroundImage
            if(image_url!=""){
                setBodyProperty("background-image", 'url('+image_url+')')
                setBodyProperty("background-repeat", "no-repeat")
                setBodyProperty("background-attachment", "fixed")
            }else{
                var color = command.style.invertedTheme==true?"#f1f1f1":"#000"
                setBodyProperty("background-color", color)
            }
            var font_color = command.style.newsContentFontColor
            setBodyProperty("color", font_color)
        }
        function setBodyWidth(width){
            setBodyProperty("width", String(width))
        }

        onLoadFinished: {
            setHtmlTheme()
            setBodyWidth(width-20)


            addToJavaScriptWindowObject("qml", qmlObj)
        }

        QtObject {
            id: qmlObj
            function openUrl(src){
                Qt.openUrlExternally(src)
            }
        }
        /*onAlert: {
            console.log(message)
        }*/
    }
}
