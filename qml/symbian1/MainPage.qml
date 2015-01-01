import QtQuick 1.0
import com.nokia.symbian 1.1
import "Main"
import "JS/main.js" as Script

Page {
    id: mainPage;

    property bool loading: false;

    property alias currentCategoryIndex: header.selectedIndex;
    onCurrentCategoryIndexChanged: {
        Script.currentCategory = currentCategoryIndex;
        internal.switchToNewsList(Script.newsList[currentCategoryIndex].categoryName);
    }

    tools: ToolBarLayout {
        enabled: !header.selecting;
        ToolButton {
            id: quitToolButton;
            iconSource: "toolbar-back";
            platformInverted: settings.invertedTheme;
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
            id: moreToolButton;
            iconSource: "toolbar-menu";
            platformInverted: settings.invertedTheme;
            onClicked: pageStack.push(Qt.resolvedUrl("MorePage.qml"));
        }
    }

    QtObject {
        id: internal;

        property variant viewComp: null;

        function findNewsListIndexByName(cate) {
            if (cate == undefined)
                var cat = "";
            else
                var cat = cate;
            for (var i = 0; i < Script.newsList.length; i++)
                if (Script.newsList[i].categoryName == cat)
                    return i;
            return null;
        }
        function switchToNewsList(cate) {
            //console.log(findNewsListByName(cate));
            var ind = findNewsListIndexByName(cate);
            if (Script.newsList[ind].tab) {
                newsListTabGroup.currentTab = Script.newsList[ind].tab;
                return;
            }
            if (!viewComp)
                viewComp = Qt.createComponent("Main/NewsListListView.qml");
            Script.newsList[ind].tab = viewComp.createObject(newsListTabGroup);
            if (cate)
                Script.newsList[ind].tab.categoryName = cate;
            else
                Script.newsList[ind].tab.categoryName = "";
            newsListTabGroup.currentTab = Script.newsList[ind].tab;
            //console.log(newsListTabGroup.privateContents.length);
        }
    }

    MainHeader {
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

    Rectangle {
        id: isBusyMask;
        anchors.fill: parent;
        color: "Black";
        opacity: loading ? constants.maskOpacity : 0.0;
        BusyIndicator {
            anchors.centerIn: parent;
            width: constants.busyIndicatorSizeLarge;
            height: width;
            running: loading;
        }
        MouseArea {
            anchors.fill: parent;
            enabled: loading;
        }
    }

    Connections {
        target: signalCenter;
        onCategoriesChanged: {
            var arr = [];
            for (var i = 0; i < Script.newsList.length; i++)
                arr.push(Script.newsList[i].categoryTitle);
            header.model = arr;
        }
    }

    Component.onCompleted: {
        Script.initialize(signalCenter, settings);
        Script.sendRequest("CATEGORY");
    }
}
