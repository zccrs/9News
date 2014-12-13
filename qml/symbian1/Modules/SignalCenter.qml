import QtQuick 1.0

QtObject {
    id: signalCenter;

    // functions
    function showMessage(icon, message) {
        switch (icon) {
        case "N":
            infoBanner.iconSource = "../Resources/gfx/tem.svg";
            break;
        default:
            break;
        }
        infoBanner.text = message;
        infoBanner.open();
    }
}
