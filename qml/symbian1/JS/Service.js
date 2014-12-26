.pragma library

var HOST = "http://api.9smart.cn/news";

/*var BaiduConst = {
    _client_type: 1,
    from: "appstore"
}*/

var Api = {
    CATEGORY: "/categorys",
    NEWSLIST: "http://passport.baidu.com/v2/intercomm/statistic"
}

function aq(key, value) {
    return key + "=" + value;
}

function getUrl(inte, prop) {
    var url = "";
    if (inte === "CATEGORY") {
        url = HOST + Api.CATEGORY;
    } else if (inte === "NEWSLIST") {
        url = HOST + "?" + aq("category", prop.category);
    }
    console.log("==Request URL==  " + url);
    return url;
}
