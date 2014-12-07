// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1
import "../js/configure.js" as ConfigureScript

PageStackWindow
{
    id:mainwindow
    showStatusBar:true
    initialPage: MainPage{}

    Binding{
        target: theme
        property: "inverted"
        value: !command.invertedTheme
    }

    Component.onCompleted: {
        ConfigureScript.systemType = "Harmattan"
    }
}
