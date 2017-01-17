.pragma library

var BASE_URL = "http://api2.9smart.cn/"
var newsCategorysUrl = BASE_URL + "articles";
var loginUrl = BASE_URL + "user"
var registerUrl = BASE_URL + "users"

function getNewsUrlByCategory(category, keyword, order) {
    if (category)
        return BASE_URL + "articles?category=" + category;

    return newsCategorysUrl;
}

function getPosterUrlByCategory(category) {

}

function getNewsContentUrlById(newsId) {
    return BASE_URL + "article/" + newsId;
}

function getUserInfoUrl(userId) {
    return BASE_URL + "user/" + userId;
}

function getMoreNewsUrlByCurrentUrl(newsUrl, baseNewsDateline) {
    if (newsUrl.indexOf("?") < 0)
        return newsUrl + "/" + baseNewsDateline + "/next/2";

    var split_str = newsUrl.split("?", 2);

    return getMoreNewsUrlByCurrentUrl(split_str[0], baseNewsDateline) + "?" + split_str[1];
}

function getCommentUrl(newsId) {
    return BASE_URL + "comments/" + newsId;
}

function getMoreCommentUrlByNewsId(newsId, baseCommentDateline) {
    return getCommentUrl(newsId) + "/" + baseCommentDateline + "/next/2";
}
