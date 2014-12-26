import QtQuick 1.0
import com.nokia.symbian 1.1
import "Main"
import "JS/main.js" as Script

Page {
    id: mainPage;

    //property alias categoryIndex: 0;

    tools: ToolBarLayout {
        enabled: !header.selecting;
        ToolButton {
            iconSource: "toolbar-back";
            platformInverted: settings.invertedTheme;
            //enabled: !header.selecting;
            onClicked: {
                if (quitTimer.running)
                    Qt.quit();
                else
                    signalCenter.showMessage("N", qsTr("Press again to quit"));
                    quitTimer.start();
            }
        }
        ToolButton {
            iconSource: "Resources/gfx/skin" + (settings.invertedTheme ? "_inverted.png" : ".png");
            platformInverted: settings.invertedTheme;
            onClicked: settings.invertedTheme = !settings.invertedTheme;
        }
        ToolButton {
            iconSource: "toolbar-search";
            platformInverted: settings.invertedTheme;
        }
        ToolButton {
            iconSource: "toolbar-menu";
            platformInverted: settings.invertedTheme;
        }
    }

    QtObject {
        id: internal;

        property variant viewComp: null;

        function updateCategory() {
            header.model = Script.categoryTitle;
        }

        function findNewsListByTitle(title) {
            for (var i = 0; i < newsListTabGroup.privateContents.length; i++) {
                if (newsListTabGroup.privateContents[i].categoryTitle == title){
                    return newsListTabGroup.privateContents[i];
                }
            }
            return null;
        }
        function addNewsList(title) {
            var exist = findNewsListByTitle(title);
            if (exist) {
                newsListTabGroup.currentTab = exist;
                console.log("Tab is already existed: " + title);
                return;
            }
            console.log("Tab is not existed: " + title);
            if (!viewComp)
                viewComp = Qt.createComponent("Main/NewsListListView.qml");
            var view = viewComp.createObject(newsListTabGroup);
            if (title)
                view.categoryTitle = title;
            else
                view.categoryTitle = "";
        }


    }

    Header {
        id: header;
        z: 3;
    }
    Item {
        id: newsListContainer;
        anchors.top: header.bottom;
        anchors.left: parent.left; anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        TabGroup {
            id: newsListTabGroup;
            anchors.fill: parent;
        }
    }

    Rectangle {
        id: titleSelectingMask;
        anchors.fill: newsListContainer;
        color: "Black";
        opacity: header.selecting ? constants.maskOpacity : 0.0;
        Behavior on opacity {
            NumberAnimation {
                duration: constants.animationDurationNormal;
            }
        }

        MouseArea {
            anchors.fill: parent;
            enabled: header.selecting;
            onClicked: header.selecting = !header.selecting;
        }
    }

    Connections {
        target: signalCenter;
        onCategoryChanged: {
            internal.updateCategory();
            Script.currentCategory = header.selectedIndex;
            Script.currentcategoryTitle = header.model[header.selectedIndex];
            //internal.getNews(Script.currentCategory);
            internal.addNewsList(Script.currentCategoryTitle);
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
