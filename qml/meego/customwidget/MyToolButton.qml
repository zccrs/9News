// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import com.nokia.meego 1.1

ToolButton{
    property bool invertedTheme: command.style.buttonInverted!=true

    platformStyle: ToolButtonStyle {
        inverted: invertedTheme
    }
}
