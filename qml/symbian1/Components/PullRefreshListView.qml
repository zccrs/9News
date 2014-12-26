import QtQuick 1.0
import com.nokia.symbian 1.1
//import com.stars.utility 1.0

ListView {
    id: listView;

    property bool pullRefreshActivated: pullRefreshIndicator.y > pullRefreshIndicator.implicitHeight * 1.5;

    ImplicitSizeItem {
        id: pullRefreshIndicator;
        implicitHeight: row.height;
        implicitWidth: row.width;
        anchors.horizontalCenter: parent.horizontalCenter;
        y: {
            if(listView.contentY < 0)
                return -root.contentY - implicitHeight - 10;
            else
                return -implicitHeight;
        }
        Row {
            id: row;
            Image {
                id: arrow;
                source: "file";
            }
            Text {
                id: hint;
                anchors.verticalCenter: arrow.verticalCenter;
                color: "#888";
                text: pullRefreshActivated ? qsTr("Release to refresh") : qsTr("Pull down to refresh");
            }
        }

    }
}
