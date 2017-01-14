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

    data += "email=" + escape(email);
    data += "&password=" + escape(password);

    utility.httpPost(callback, loginUrl, data);
}

function register(email, nickname, password1, password2, callback) {
    var data = "";

    data += "email=" + escape(email);
    data += "&nickname=" + escape(nickname);
    data += "&password=" + escape(password1);
    data += "&repassword=" + escape(password2);

    utility.httpPost(callback, registerUrl, data);
}
