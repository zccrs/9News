import QtQuick 1.0

QtObject {
    id: settings;

    // Theme
    property bool invertedTheme: true;
    property string themeName: qsTr("Normal White Theme");

    // General Settings
    property bool noPicMode: false;
    property bool loadPicOnlyWithWifi: false;
    property bool fullscreenWhenScrolling: false;
    property bool automaticCheckForUpdate: false;
}
