import QtQuick 1.0
import com.nokia.symbian 1.1
import com.star.utility 1.0

ListView {
    id: listView;

    property bool pullRefreshActivated: pullRefreshIndicator.y > pullRefreshIndicator.implicitHeight * 1.5;

    signal refreshActivated;

    ImplicitSizeItem {
        id: pullRefreshIndicator;
        implicitHeight: row.height;
        implicitWidth: row.width;
        anchors.horizontalCenter: parent.horizontalCenter;
        y: {
            if(listView.contentY < 0)
                return -listView.contentY - implicitHeight - 10;
            else
                return -implicitHeight;
        }
        Row {
            id: row;
            Image {
                id: arrow;
                source: "../Resources/gfx/pull_down.svg";
                rotation: pullRefreshActivated ? 180 : 0;
                Behavior on rotation {
                    NumberAnimation {
                        duration: constants.animationDurationFast;
                    }
                }
            }
            Text {
                id: hint;
                anchors.verticalCenter: arrow.verticalCenter;
                color: "#888";
                text: pullRefreshActivated ? qsTr("Release to refresh") : qsTr("Pull down to refresh");
            }
        }
    }
    MonitorMouseEvent {
        id: mouseEventMonitor;
        target: listView;
        onMouseRelease: {
            if (pullRefreshActivated)
                refreshActivated();
        }
    }
}
