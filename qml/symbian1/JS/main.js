.pragma library

Qt.include("Service.js");

var _signalCenter, _settings;
var category, categoryTitle;
var currentCategory;
var newsList = new Array(30);

function initialize(sc, s) {
    _signalCenter = sc;
    _settings = s;
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
                try {
                    onSucceed(xhr.responseText);
                    //signalcenter.loadFinished();
                } catch (err) {
                    onFail(qsTr("Loading error."));
                }
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
    console.log(json);
    var obj = JSON.parse(json);
    category = obj.categorys;
    categoryTitle = obj.titles;
    _signalCenter.categoryChanged();
    console.log(newsList[0]);
}

// News list
function getNewsList(json) {
    console.log(json);
    var obj = JSON.parse(json);
    if (newsList[currentCategory] === undefined) {
        newsList[currentCategory] = new Object();
    }
    newsList[currentCategory].articles = obj.articles;
    newsList[currentCategory].pager = obj.pager;
    _signalCenter.newsListChanged();
}
