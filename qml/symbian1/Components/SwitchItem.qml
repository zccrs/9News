import QtQuick 1.0
import com.nokia.symbian 1.1

Item {
    id: root;
    width: parent.width;
    height: switchButton.height + constants.marginSmall * 2;

    property bool platformInverted: false;
    property alias checked: switchButton.checked;
    property alias title: titleLabel.text;

    signal clicked;

    Text {
        id: titleLabel;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.left: parent.left;
        anchors.leftMargin: constants.marginMedium;
        color: platformInverted ? "Black" : "White";
    }
    Switch {
        id: switchButton;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.right: parent.right;
        anchors.rightMargin: constants.marginMedium;
        platformInverted: platformInverted;
        onClicked: {
            root.clicked();
        }
    }
}
