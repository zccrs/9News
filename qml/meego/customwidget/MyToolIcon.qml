// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import com.nokia.meego 1.1

ToolIcon{
    property bool invertedTheme: command.style.toolBarInverted
    property string iconId

    iconSource: handleIconSource(iconId)

    platformStyle: ToolItemStyle{
        inverted: invertedTheme
    }

    function handleIconSource(iconId) {
        var prefix = "icon-m-"
        if (iconId.indexOf(prefix) !== 0)
            iconId =  prefix.concat(iconId).concat(invertedTheme ? "" : "-white");
        return "image://theme/" + iconId;
    }
}
