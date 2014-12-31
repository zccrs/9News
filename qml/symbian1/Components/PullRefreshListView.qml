import QtQuick 1.0
import com.nokia.symbian 1.1
import com.star.utility 1.0

ListView {
    id: listView;

    property bool pullRefreshActivated: pullRefreshIndicator.y > pullRefreshIndicator.implicitHeight * 1.5;
    property bool loading: false;

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
                visible: !loading;
                rotation: pullRefreshActivated ? 180 : 0;
                Behavior on rotation {
                    NumberAnimation {
                        duration: constants.animationDurationFast;
                    }
                }
            }
            BusyIndicator {
                id: busy;
                anchors.fill: arrow;
                visible: loading;
                running: visible;
            }
            Text {
                id: hint;
                anchors.verticalCenter: arrow.verticalCenter;
                color: "#888";
                text: loading ? qsTr("Refreshing") : pullRefreshActivated ? qsTr("Release to refresh") : qsTr("Pull down to refresh");
            }
        }
    }
    MonitorMouseEvent {
        id: mouseEventMonitor;
        target: listView;
        onMouseRelease: {
            if (!loading && pullRefreshActivated)
                refreshActivated();
        }
    }
}
