import QtQuick 1.0

Item {
    id: root;
    width: parent.width;
    height: 22;

    property alias title: titleLabel.text;
    property bool platformInverted: false;

    Text {
        id: titleLabel;
        color: platformInverted ? "Black" : "White";
        anchors.verticalCenter: parent.verticalCenter;
        anchors.left: parent.left;
        anchors.leftMargin: constants.marginMedium;
    }
    Image {
        anchors.left: titleLabel.right;
        anchors.leftMargin: title == "" ? 0 : constants.marginMedium;
        anchors.right: parent.right;
        anchors.rightMargin: constants.marginMedium;
        anchors.verticalCenter: parent.verticalCenter;
        source: ("../Resources/gfx/cutting_line" + (platformInverted ? "_inverted" : "") + ".png");
    }
}
