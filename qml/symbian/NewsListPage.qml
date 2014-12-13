<<<<<<< HEAD
// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import "../utility/newsListPage"

NewsList{
    id: root

    BusyIndicator {
        id: busyIndicator
        running: visible
        visible: root.isBusy
        anchors.centerIn: parent
        width: 50
        height: 50
    }

    ScrollBar {
        platformInverted: command.invertedTheme
        flickableItem: root
        anchors {
            right: parent.right
            top: parent.top
        }
    }
}
=======
// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import "../utility/newsListPage"

NewsList{
    id: root

    footer: componentFooter

    Component{
        id: componentFooter

        Item{
            width: parent.width
            height: textLoadMoreNews.implicitHeight+20
            Text{
                id: textLoadMoreNews
                text: qsTr("load more...")
                anchors.centerIn: parent
                visible: newsList.count>1
                color: command.invertedTheme?"black":"#ccc"

                MouseArea{
                    anchors.fill: parent
                    enabled: newsList.isBusy
                    onClicked: {
                        textLoadMoreNews.color = "#888"
                        newsList.addMoreNews()//增加新闻
                    }
                }
            }
            //newsList对象在MainPage中，因为在compoentFooter中无法引用的root对象，所以这也是不得已而为之
        }
    }

    BusyIndicator {
        id: busyIndicator
        running: visible
        visible: root.isBusy
        anchors.centerIn: parent
        width: 50
        height: 50
    }

    ScrollBar {
        platformInverted: command.invertedTheme
        flickableItem: root
        anchors {
            right: parent.right
            top: parent.top
        }
    }
}
>>>>>>> 5eadeb2e4c633312e53c5ed6b7be596665fabe33
