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
