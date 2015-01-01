import QtQuick 1.0
import com.nokia.symbian 1.1

ImplicitSizeItem {
    id: header;
    implicitWidth: screen.width;
    implicitHeight: titleArea.height;

    property alias title: titleLabel.text;

    Rectangle {
        id: titleArea;
        width: parent.width;
        height: constants.headerHeight;
        gradient: Gradient {
            GradientStop {
                position: 0;
                color: "White";
            }
            GradientStop {
                position: 1;
                color: "LightGrey";
            }
        }
        Text {
            id: titleLabel;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left;
            anchors.leftMargin: constants.headerTitleLeftMargin;
        }
    }
}
