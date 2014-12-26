import QtQuick 1.0
import "../Components"
import "../JS/main.js" as Script

PullRefreshListView {
    id: newsListListView;

    //property int categoryIndex: -1;
    //onCategoryIndexChanged: internal.getNewsList();
    property string categoryTitle: "";
    onCategoryTitleChanged: {
        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        internal.getNewsList(categoryTitle);
    }

    QtObject {
        id: internal;

        function getNewsList(cate) {
            var prop = { category: cate };
            //Script.sendRequest("NEWSLIST", prop);
        }

        function updateNewsList() {
            newsListListView.model = Script.newsList[header.selectedIndex].articles;
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
}
