// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import com.nokia.meego 1.1

Menu{
    property bool invertedTheme: command.style.menuInverted!=true

    platformStyle: MenuStyle{
        inverted: invertedTheme
        //property url background: "image://theme/meegotouch-menu-background"+(invertedTheme? "-inverted" : "")
    }
}
