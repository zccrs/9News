import QtQuick 1.0
import com.nokia.symbian 1.1
import com.star.widgets 1.0
import com.star.utility 1.0
import "../Components"
import "../JS/utility.js" as Utility

Component {
    ImplicitSizeItem {
        id: root;
        implicitWidth: parent.width;
        implicitHeight: contentColumn.height + constants.marginMedium * 2;

        Item {
            id: paddingItem;
            anchors {
                left: parent.left; leftMargin: constants.marginMedium;
                right: parent.right; rightMargin: constants.marginMedium;
                top: parent.top; topMargin: constants.marginMedium;
                bottom: parent.bottom; bottomMargin: constants.marginMedium;
            }
        }

        property variant thumbsModel: (modelData.thumbs != null ? modelData.thumbs : []);
        Column {
            id: contentColumn;
            anchors.left: paddingItem.left;
            anchors.right: paddingItem.right;
            anchors.top: paddingItem.top;
            spacing: constants.marginSmall;
            Text {
                id: titleText;
                color: settings.invertedTheme ? "Black" : "White";
                width: parent.width;
                wrapMode: Text.WrapAnywhere;
                text: modelData.topic;
            }
            ListView {
                id: thumbsListView;
                clip: true;
                spacing: constants.marginSmall;
                orientation: ListView.Horizontal;
                model: root.thumbsModel;
                width: parent.width;
                height: count == 0 ? 0 : 80;
                delegate: Component {
                    Image {
                        source: modelData.thumburl;
                        height: parent.height;
                        fillMode: Image.PreserveAspectFit;
                    }
                }
            }
            Item {
                width: parent.width;
                height: sourceText.height;
                Text {
                    id: sourceText;
                    anchors.left: parent.left;
                    text: modelData.source;
                    color: settings.invertedTheme ? "Black" : "White";
                }
                Text {
                    id: timeText;
                    anchors.right: parent.right;
                    text: Utility.humandate(modelData.dateline);
                    color: settings.invertedTheme ? "Black" : "White";
                }
            }
        }
        CuttingLine {
            anchors.bottom: parent.bottom;
            width: parent.width;
            //visible: command.style.cuttingLineVisible;
        }

        Component.onCompleted: {
            //
        }
    }
}
