import QtQuick 1.0
import com.nokia.symbian 1.1

ImplicitSizeItem {
    id: header;
    implicitWidth: screen.width;
    implicitHeight: titleArea.height + categoryArea.height;

    property alias selectedIndex: categoryList.currentIndex;

    //property alias model: categoryList.model;
    property variant model: [];
    onModelChanged: {
        console.log(">>> Category Title Changed")
        categoryList.model = model;
        selectedIndex = 0;
    }

    property bool selecting: false;
    onSelectingChanged: internal.layoutHeader();

    QtObject {
        id: internal;

        function layoutHeader() {
            if (!selecting)
                categoryArea.height = 0;
            else if (categoryList.count > 4)
                categoryArea.height = constants.headerHeight * 4;
            else
                categoryArea.height = constants.headerHeight * categoryList.count;
        }
    }

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
        Rectangle {
            anchors.fill: parent;
            color: "Black";
            opacity: selecting ? 0.6 : 0.0;
        }
        Text {
            id: titleLabel;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left;
            anchors.leftMargin: constants.headerTitleLeftMargin;
            text: model[selectedIndex];
        }
        MouseArea {
            id: titleMouseArea;
            anchors.fill: parent;
            onClicked: {
                selecting = !selecting;
            }
        }
    }
    Item {
        id: categoryArea;
        width: parent.width;
        height: 0;
        anchors.left: parent.left; anchors.right: parent.right;
        anchors.top: titleArea.bottom;
        /*states: [
            State {
                name: "show";
                PropertyChanges {
                    target: categoryArea;

                }
            }
        ]*/
        Behavior on height {
            NumberAnimation {
                //target: categoryArea;
                duration: 300;
            }
        }
        Rectangle {
            anchors.fill: parent;
            color: "White";
        }
        ListView {
            id: categoryList;
            anchors.fill: parent;
            clip: true;
            enabled: selecting;
            model: model;
            delegate: categoryListDelegate;
            Component {
                id: categoryListDelegate;
                Item {
                    width: header.width;
                    height: constants.headerHeight;
                    Rectangle {
                        anchors.fill: parent;
                        color: "#000000";
                        opacity: delegateMouseArea.pressed ? 0.6 : 0;
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter;
                        anchors.left: parent.left;
                        anchors.leftMargin: constants.headerTitleLeftMargin;
                        color: ListView.isCurrentItem ? "Grey" : "Black";
                        text: modelData;
                    }
                    MouseArea {
                        id: delegateMouseArea;
                        anchors.fill: parent;
                        onClicked: {
                            categoryList.currentIndex = index;
                            selecting = !selecting;
                        }
                    }
                }
            }
        }
    }
}
