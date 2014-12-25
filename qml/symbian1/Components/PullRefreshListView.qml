import QtQuick 1.0
import com.stars.utility 1.0

ListView {
    id: listView;

    Item {
        id: pullDownItem

        property bool active: y>implicitHeight*1.5

        //text: active?qsTr("loosen refresh"):qsTr("pull down refresh")
        //color: "#888"
        anchors.horizontalCenter: parent.horizontalCenter
        y: {
            if(root.contentY<0)
                return -root.contentY-implicitHeight-10
            else
                return -implicitHeight
        }
    }
}
