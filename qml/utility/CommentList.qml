// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.zccrs.widgets 1.0
import "../js/api.js" as Api

Item{
    id: root

    property string newsId
    //记录新闻的aid
    property alias listView: commentList
    property bool isBusy: false
    property string lastCommentDateline

    onNewsIdChanged: {
        objApi.loadComment()
    }

    function refreshComment(){
        if(isBusy)
            return

        //刷新评论内容
        mymodel.clear()
        objApi.loadComment()
    }

    QtObject{
        id: objApi

        function loadComment(){
            if(isBusy)
                return

            if(newsId!=-1){
                isBusy = true

                var url = Api.getCommentUrl(newsId)
                utility.httpGet(getCommentFinished, url)
            }
        }

        function getCommentFinished(error, data){
            isBusy = false

            if(error){
                return
            }

            data = JSON.parse(utility.fromUtf8(data))
            if(!data.error){
                if (data.pager.count==0){
                    if (mymodel.count == 0)
                        command.showBanner(qsTr("Nobody comments, Come and grab the sofa now!"))
                    else
                        command.showBanner(qsTr("No more"));
                    return
                }

                var comments = data.comments

                for(var i in comments){
                    var comment = comments[i]

                    var obj={
                        "uid": comment.uid,
                        "avatarUrl": comment.user.avatar,
                        "nickName": comment.user.nickname,
                        "date": command.fromTime_t(comment.dateline),
                        "message": comment.content,
                        "agree_count": comment.agrees,
                        "against_count": comment.againsts,
                        "phoneName": comment.model?comment.model:qsTr("unknown")
                    }

                    mymodel.append(obj)
                }

                if (comments.length > 0)
                    lastCommentDateline = comments[comments.length - 1].dateline;
            }else{
                command.showBanner(data.error)
            }
        }
    }

    Item{
        anchors.fill: parent
        clip: true
        anchors.bottomMargin: command.style.penetrateToolBar?
                                  -main.pageStack.toolBar.height:0

        ListView{
            id: commentList

            spacing: 10
            anchors.fill: parent
            anchors.bottomMargin: -parent.anchors.bottomMargin

            model: ListModel{
                id: mymodel
            }

            delegate: listComponent
            footer: componentFooter
        }
    }

    Component{
        id: listComponent

        Item{
            width: parent.width
            height: imageAvatar.height+textContent.implicitHeight+ 50

            MaskImage{
                id: imageAvatar

                width: command.style.commentAvatarWidth
                height: width
                maskSource: "qrc:/images/mask.bmp"
                sourceSize.width: width
                source: command.showNewsImage?
                            command.style.loadingImage:command.style.defaultImage

                Component.onCompleted: {
                    source = avatarUrl
                }
            }

            Text{
                id: textNick

                text: nickName
                anchors.left: imageAvatar.right
                anchors.leftMargin: 10
                color: command.style.newsInfoFontColor
                font.pixelSize: command.style.newsInfosFontPixelSize
            }
            Text{
                id: textPhoneName

                text: phoneName
                anchors.left: textNick.right
                anchors.leftMargin: 10
                color: command.style.newsInfoFontColor
                font.pixelSize: command.style.newsInfosFontPixelSize
            }
            Text{
                id: textDate

                text: date
                anchors.left: textPhoneName.right
                anchors.leftMargin: 10
                color: command.style.newsInfoFontColor
                font.pixelSize: command.style.newsInfosFontPixelSize
            }

            Text{
                id: textContent

                anchors.top: imageAvatar.bottom
                anchors.topMargin: 10
                text: message
                width: parent.width
                wrapMode: Text.WordWrap
                color: command.style.newsContentFontColor
                font.pixelSize: command.newsContentFontSize
            }

            Row {
                id: rightBottomRow

                anchors {
                    right: parent.right
                    bottom: parent.bottom
                }

                spacing: 10

                Text {
                    text: "<a href='http'>%1(%2)</a>".replace("%1", qsTr("Agree")).replace("%2", agree_count);
                    font.pixelSize: command.style.newsInfosFontPixelSize
                }
                Text {
                    text: "<a href='http'>%1(%2)</a>".replace("%1", qsTr("Against")).replace("%2", against_count);
                    font.pixelSize: command.style.newsInfosFontPixelSize
                }
            }

            CuttingLine{
                anchors {
                    left: parent.left
                    right: rightBottomRow.left
                    rightMargin: 10
                    verticalCenter: rightBottomRow.verticalCenter
                }

                visible: command.style.cuttingLineVisible
            }
        }
    }

    ToTopIcon{
        target: commentList
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        width: command.style.toUpIconWidth
        z:1
    }

    Component{
        id: componentFooter

        Item{
            width: commentList.width
            height: textLoadMoreNews.implicitHeight+40
            Text{
                id: textLoadMoreNews
                text: qsTr("Load more...")
                anchors.centerIn: parent
                visible: commentList.count>1
                color: command.style.newsTitleFontColor
                font.pixelSize: command.newsTitleFontSize
            }
            //newsList对象在MainPage中，因为在compoentFooter中无法引用的root对象，所以这也是不得已而为之
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    var newUrl = Api.getMoreCommentUrlByNewsId(newsId, lastCommentDateline)

                    utility.httpGet(objApi, "getCommentFinished(QVariant,QVariant)", newUrl)
                }
            }
        }
    }
}
