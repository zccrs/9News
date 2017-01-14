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

            data = JSON.parse(data)
            if(data.error==0){
                var comments = data.comments

                if(data.pager.count==0){
                    command.showBanner(qsTr("Nobody comments, Come and grab the sofa now!"))
                    return
                }

                for(var i in comments){
                    var comment = comments[i]

                    var obj={
                        "uid": comment.uin,
                        "avatarUrl": comment.avatar,
                        "nickName": comment.nickname,
                        "date": command.fromTime_t(comment.dateline),
                        "message": comment.message,
                        "score": comment.score,
                        "phoneName": comment.model?comment.model:qsTr("unknown")
                    }

                    mymodel.append(obj)
                }
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
        }
    }

    Component{
        id: listComponent

        Item{
            width: parent.width
            height: imageAvatar.height+textContent.implicitHeight+20

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
                anchors.left: textNick.left
                anchors.bottom: imageAvatar.bottom
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
            CuttingLine{
                anchors.bottom: parent.bottom
                width: parent.width
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
}
