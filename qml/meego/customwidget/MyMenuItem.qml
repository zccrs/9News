// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import com.nokia.meego 1.1
import QtQuick 1.1

MenuItem{
    id: root

    property bool invertedTheme: command.style.menuInverted!=true

    platformStyle: MenuItemStyle{
                inverted: invertedTheme
            }

    Binding{
        target: children[0]
        property: "source"
        value: root.parent.children.length == 1 ? (pressed ? "image://theme/meegotouch-list"+style.__invertedString+"-background-pressed" : "image://theme/meegotouch-list"+style.__invertedString+"-background")
                                                : root.parent.children[0] == root ? (pressed ? "image://theme/meegotouch-list"+style.__invertedString+"-background-pressed-vertical-top" : "image://theme/meegotouch-list"+style.__invertedString+"-background-vertical-top")
                                                : root.parent.children[root.parent.children.length-1] == root ? (pressed ? "image://theme/meegotouch-list"+style.__invertedString+"-background-pressed-vertical-bottom" : "image://theme/meegotouch-list"+style.__invertedString+"-background-vertical-bottom")
                                                : (pressed ? "image://theme/meegotouch-list"+style.__invertedString+"-background-pressed-vertical-center" : "image://theme/meegotouch-list"+style.__invertedString+"-background-vertical-center")
    }
}
