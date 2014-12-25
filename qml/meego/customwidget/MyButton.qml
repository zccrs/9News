// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import com.nokia.meego 1.1

Button{
    property bool invertedTheme: command.style.buttonInverted!=true

    platformStyle: ButtonStyle {
        textColor: invertedTheme?"#fff":"#000"

        property string __invertedString: invertedTheme? "-inverted" : ""
        property string background: "image://theme/meegotouch-button" + __invertedString + "-background" + (position ? "-" + position : "")
        property string pressedBackground: "image://theme/meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
        property string disabledBackground: "image://theme/meegotouch-button" + __invertedString + "-background-disabled" + (position ? "-" + position : "")
        property string checkedBackground: "image://theme/meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
        property string checkedDisabledBackground: "image://theme/meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
    }
}
