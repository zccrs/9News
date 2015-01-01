import QtQuick 1.0
import com.nokia.symbian 1.1
import "Components"

Page {
    id: morePage;

    tools: ToolBarLayout {
        ToolButton {
            id: backToolButton;
            iconSource: "toolbar-back";
            platformInverted: settings.invertedTheme;
            onClicked: pageStack.pop();
        }
    }

    Header {
        id: header;
        title: qsTr("Settings");
    }
    Flickable {
        id: flickable;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: header.bottom;
        anchors.bottom: parent.bottom;
        contentHeight: column.height;
        contentWidth: width;
        clip: true;
        flickableDirection: Flickable.VerticalFlick;
        Column {
            id: column;
            width: parent.width;
            anchors.top: parent.top;
            Item {
                id: logoBanner;
                width: parent.width;
                height: 120;
                Image {
                    id: logoImage;
                    anchors.centerIn: parent;
                    source: "Resources/gfx/logo.svg";
                }
            }
            Text {
                id: versionLabel;
                anchors.right: parent.right;
                anchors.rightMargin: constants.marginMedium;
                text: qsTr("Version:%1".arg(constants.version));
            }
            TitleLine {
                title: qsTr("General Settings");
                platformInverted: settings.invertedTheme;
            }
            SwitchItem {
                id: noPicModeSwitchItem;
                title: qsTr("No pictures mode");
                checked: settings.noPicMode;
                platformInverted: settings.invertedTheme;
                onClicked: settings.noPicMode = checked;
            }
            SwitchItem {
                id: loadPicOnlyWithWifiSwitchItem;
                title: qsTr("Load pictures only with WIFI");
                checked: settings.loadPicOnlyWithWifi;
                platformInverted: settings.invertedTheme;
                onClicked: settings.loadPicOnlyWithWifi = checked;
            }
            SwitchItem {
                id: fullscreenWhenScrollingSwitchItem;
                title: qsTr("Fullscreen when scrolling");
                checked: settings.fullscreenWhenScrolling;
                platformInverted: settings.invertedTheme;
                onClicked: settings.fullscreenWhenScrolling = checked;
            }
            SwitchItem {
                id: automaticCheckForUpdateSwitchItem;
                title: qsTr("Automatic check for update");
                checked: settings.automaticCheckForUpdate;
                platformInverted: settings.invertedTheme;
                onClicked: settings.automaticCheckForUpdate = checked;
            }
            TitleLine {
                title: qsTr("Font pixel size");
                platformInverted: settings.invertedTheme;
            }
            TitleLine {
                title: qsTr("Image saved path");
                platformInverted: settings.invertedTheme;
            }
            TitleLine {
                title: qsTr("Preferences settings");
                platformInverted: settings.invertedTheme;
            }
            ToolButton {
                id: themeToolButton;
                platformInverted: settings.invertedTheme;
                anchors.left: parent.left;
                anchors.leftMargin: constants.marginMedium;
                anchors.right: parent.right;
                anchors.rightMargin: constants.marginMedium;
                text: qsTr("Theme:%1".arg(settings.themeName));
                Image {
                    source: "Resources/gfx/selector.svg";
                    anchors.right: parent.right;
                    anchors.rightMargin: constants.marginSmall;
                    anchors.verticalCenter: parent.verticalCenter;
                }
            }
            TextField {
                id: signatureTextField;
                anchors.left: parent.left;
                anchors.leftMargin: constants.marginMedium;
                anchors.right: parent.right;
                anchors.rightMargin: constants.marginMedium;
                placeholderText: qsTr("Signature");
            }
            TitleLine {
                platformInverted: settings.invertedTheme;
            }
            ToolButton {
                id: checkForUpdateToolButton;
                platformInverted: settings.invertedTheme;
                anchors.left: parent.left;
                anchors.leftMargin: constants.marginMedium;
                anchors.right: parent.right;
                anchors.rightMargin: constants.marginMedium;
                text: qsTr("Check for update");
            }
        }
    }
}
