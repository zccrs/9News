.pragma library

var newsCategorysUrl = "http://api.9smart.cn/news/categorys"
//获取新闻分类的url
function getNewsUrlByCategory(category){
    //返回获取类别为category的新闻的url
    return "http://api.9smart.cn/news"+(category?("?category="+category):"")
}
function getPosterUrlByCategory(category){
    //返回获取类别为category的大海报的url
    return "http://api.9smart.cn/covers"+(category?("?category="+category):"")
}
function getNewsContentUrlById(newsId){
    //返回新闻Id为newsId的新闻的url
    return "http://api.9smart.cn/new/"+newsId
}
