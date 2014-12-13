import QtQuick 1.0
import com.nokia.symbian 1.1

Page {
    id: mainPage;

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back";
            onClicked: {
                if (quitTimer.running)
                    Qt.quit();
                else
                    signalCenter.showMessage("N", qsTr("Press again to quit"));
                    quitTimer.start();
            }
        }
        ToolButton {
            iconSource: "Resources/gfx/tem.svg";
            onClicked: settings.invertedTheme = !settings.invertedTheme;
        }
        ToolButton {
            iconSource: "toolbar-search";
        }
        ToolButton {
            iconSource: "toolbar-menu";
        }
    }
}
