import QtQuick 1.0
import com.nokia.symbian 1.1
import "Main"
import "JS/main.js" as Script

Page {
    id: mainPage;

    //property alias categoryIndex: 0;

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
            onClicked: header.model = listModel2;
        }
        ToolButton {
            iconSource: "toolbar-menu";
        }
    }

    QtObject {
        id: internal;

        function updateCategory() {
            header.model = Script.categoryTitle;
        }

        function getNews(cate) {
            var prop = {
                category: cate
            }
            Script.sendRequest("NEWSLIST", prop);
        }

        function updateNewsList() {
            //
        }
    }

    Header {
        id: header;
    }


    Connections {
        target: signalCenter;
        onCategoryChanged: {
            internal.updateCategory();
            Script.currentCategory = header.selectedIndex;
            internal.getNews(Script.category[header.selectedIndex]);
        }
        onNewsListChanged: {
            internal.updateNewsList();
        }
    }

    Component.onCompleted: {
        Script.initialize(signalCenter, settings);
        Script.sendRequest("CATEGORY");
    }
}
