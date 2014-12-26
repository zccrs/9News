import QtQuick 1.0
import "../Components"
import "../JS/main.js" as Script

PullRefreshListView {
    id: newsListListView;

    property string categoryName: "_";
    onCategoryNameChanged: {
        internal.getNewsList();
    }

    QtObject {
        id: internal;

        function getNewsList() {
            var prop = { category: categoryName };
            Script.sendRequest("NEWSLIST", prop);
        }

        function updateNewsList() {
            newsListListView.model = Script.newsList[Script.currentCategory].articles;
        }
    }

    anchors.fill: parent;
    //header: newsListViewHeader;
    clip: true;
    delegate: NewsListListViewDelegate {}
    // Slides
    /*Component {
        id: newsListViewHeader;
        ListView {
            orientation: ListView.Horizontal;
        }
    }*/

    onRefreshActivated: {
        internal.getNewsList();
    }

    Connections {
        target: signalCenter;
        onNewsListChanged: {
            if (p_category === categoryName) {
                internal.updateNewsList();
            }
        }
    }
}
