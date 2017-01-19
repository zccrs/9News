.pragma library

Qt.include("api.js")

var utility;
var command;

function initServer(u, c) {
    utility = u;
    command = c;

    userData.uid = utility.value("uid");
    userData.auth = utility.stringUncrypt(utility.value("auth"), userData.uid);
}

function aboutDestory() {

}

var userData = {
    uid: "",
    auth: ""
}

function setUserData(uid, auth) {
    userData.uid = uid;
    userData.auth = auth;

    utility.setValue("uid", userData.uid);
    utility.setValue("auth", utility.stringEncrypt(userData.auth, userData.uid));
}

function logion(email, password, callback) {
    var data = "";

    data += "email=" + encodeURIComponent(email);
    data += "&password=" + encodeURIComponent(password);

    utility.httpPost(callback, loginUrl, data);
}

function register(email, nickname, password1, password2, callback) {
    var data = "";

    data += "email=" + encodeURIComponent(email);
    data += "&nickname=" + encodeURIComponent(nickname);
    data += "&password=" + encodeURIComponent(password1);
    data += "&repassword=" + encodeURIComponent(password2);

    utility.httpPost(callback, registerUrl, data);
}

function sendComment(newsId, message, phoneModel, callback) {
    var url = utility.stringToUrl(getCommentUrl(newsId));
    var data = "";

    data += "type=news&content=" + encodeURIComponent(message + command.signature);
    data += "&model=" + encodeURIComponent(phoneModel);
    url = utility.addEncodedQueryItem(url, "auth", userData.auth);

    utility.httpPost(callback, url, data);
}

// 回复楼中楼
function sendSubComment(commentId, message, phoneModel, callback) {
    var url = utility.stringToUrl(getCommentUrl(commentId) + "/reply");
    var data = "";

    data += "content=" + encodeURIComponent(message + command.signature);
    data += "&model=" + encodeURIComponent(phoneModel);
    url = utility.addEncodedQueryItem(url, "auth", userData.auth);

    utility.httpPost(callback, url, data);
}

function agreeComment(newsId, callback) {
    var url = getCommentUrl(newsId) + "/action?type=同意";

    utility.httpGet(callback, url);
}

function againstComment(newsId, callback) {
    var url = getCommentUrl(newsId) + "/action?type=反对";

    utility.httpGet(callback, url);
}

function getNewsBrowserUrl(newsId) {
    return "http://www.9smart.cn/article/" + newsId;
}

function getAppInfoById(appId, callback) {
    var url = BASE_URL + "app/" + appId;

    utility.httpGet(callback, url);
}
