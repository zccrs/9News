.pragma library

Qt.include("Service.js");

var _signalCenter, _settings;
//var category = [""], categoryTitle = [""];
var currentCategory = 0;
//var currentCategoryName, currentCategoryTitle;
var newsList = [];
//var categoryTitles = [];

function initialize(sc, s) {
    _signalCenter = sc;
    _settings = s;
    newsList.push(createNewsListObject("", qsTr("All")));
}

// Common functions
function sendHttpRequest(method, url, data, onSucceed, onFail) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        switch (xhr.readyState) {
        case xhr.OPENED: break; //signalcenter.loadStarted();break;
        case xhr.HEADERS_RECEIVED: {
            if (xhr.status != 200)
                onFail(qsTr("Connection Error with code ") + xhr.status + " : " + xhr.statusText);
            break;
        }
        case xhr.DONE: {
            if (xhr.status == 200) {
                //try {
                    onSucceed(xhr.responseText);
                    //signalcenter.loadFinished();
                //} catch (err) {
                //    console.log("------------------LOADINGERROR??????!!!!!!");
                //    onFail(qsTr("Loading error."));
                //}
            } else {
                onFail(qsTr("Error."));
            }
            break;
        }
        }
    }
    if (method === "GET") {
        xhr.open("GET", url);
        xhr.send();
    }
    if (method === "POST") {
        xhr.open("POST", url);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("Content-Length", data.length);
        xhr.send(data);
    }
}

function showError(msg) {
    _signalCenter.showMessage("E", msg);
}

function sendRequest(inte, prop) {
    if (inte === "CATEGORY") {
        sendHttpRequest("GET", getUrl(inte), "", getCategory, showError);
    } else if (inte === "NEWSLIST") {
        sendHttpRequest("GET", getUrl(inte, prop), "", getNewsList, showError);
    }
}

// Category
function getCategory(json) {
    var obj = JSON.parse(json);
    for (var i = 0; i < obj.categorys.length; i++) {
        //category.push(obj.categorys[i]);
        //categoryTitle.push(obj.titles[i]);
        newsList.push(createNewsListObject(obj.categorys[i], obj.titles[i]));
    }
    _signalCenter.categoriesChanged();
}

function createNewsListObject(cate, titl) {
    var obj = new Object();
    obj.categoryName = cate;
    obj.categoryTitle = titl;
    obj.tab = null;
    return obj;
}

// News list
function getNewsList(json) {
    console.log(json);
    var obj = JSON.parse(json);
    newsList[currentCategory].articles = obj.articles;
    newsList[currentCategory].pager = obj.pager;
    _signalCenter.newsListChanged(newsList[currentCategory].categoryName);
}
