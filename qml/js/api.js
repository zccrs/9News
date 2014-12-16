.pragma library

var loginUrl = ""
//用户登录url
var newsCategorysUrl = "http://api.9smart.cn/news/categorys"
//获取新闻分类的url
function getNewsUrlByCategory(category, keyword, order){
    //返回获取类别为category的新闻的url
    return "http://api.9smart.cn/news"+
            "?category="+(category?category:"")+
            "&keyword="+(keyword?keyword:"")+
            "&order="+(order?order:"")
}
function getPosterUrlByCategory(category){
    //返回获取类别为category的大海报的url
    return "http://api.9smart.cn/covers"+(category?("?category="+category):"")
}
function getNewsContentUrlById(newsId){
    //返回新闻Id为newsId的新闻的url
    return "http://api.9smart.cn/new/"+newsId
}
function getMoreNewsUrlByCurrentUrl(currentUrl, currentId){
    //获取加载更多新闻的url
    return setUrlProperty(currentUrl, "aid", currentId)
}
function setUrlProperty(url, name, value){
    //设置url中参数name的值
    var reg = new RegExp(name+"=[^&]*")
    if(url.match(reg)){//如果参数name存在
        return url.replace(reg, name+"="+value)
    }else{
        if(url.indexOf("?")>=0){//如果问号存在
            return url+"&"+name+"="+value
        }else{
            return url+"?"+name+"="+value
        }
    }
}
function getUrlProperty(url, name){
    //获取url中参数name的值
    var reg = new RegExp(name+"=[^&]*")
    var value = reg.exec(url)
    return value.replace(name+"=", "")
}
