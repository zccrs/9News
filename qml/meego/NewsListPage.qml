// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import "../utility/newsListPage"

NewsList{
    id: root

    BusyIndicator {
        id: busyIndicator
        running: visible
        visible: isBusy
        anchors.centerIn: parent
        width: 100
        height: 100

        platformStyle: BusyIndicatorStyle {
                 period: 800
                 size: "large"
             }
    }

    ScrollDecorator {
        flickableItem: root
    }
}
