.pragma library

var systemType = "Symbian"
var style = {
    metroTitleFontPointSize:systemType == "Symbian"?11:22,
    //Metro界面上方大标题的最大字体大小
    newsListFontPointSize:systemType == "Symbian"?7:14,
    //新闻列表中新闻标题的字体大小
    newsInfosFontPointSize:systemType == "Symbian"?5:10,
    //新闻列表中新闻来源和发表时间等新闻信息的字体大小
    flipchartsTitleFontPointSize:systemType == "Symbian"?5:10
    //大海报上新闻标题的字体大小
}

//Object.defineProperties(style, {})
