.pragma library

Qt.include("api.js")

var utility;

function initServer(u) {
    utility = u;

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
    var url = getCommentUrl(newsId) + "?auth=" + decodeURI(userData.auth);
    var data = "";

    data += "type=news&content=" + encodeURIComponent(message);
    data += "&model=" + encodeURIComponent(phoneModel);

    utility.httpPost(callback, url, data);
}
