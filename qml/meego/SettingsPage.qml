// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.zccrs.utility 1.0
import "../utility"
import "./customwidget"
import "../js/server.js" as Server

MyPage{
    id: root

    function selectPath(){
        fileDialog.inverseTheme = command.style.dialogInverted
        fileDialog.chooseType = FilesDialog.FolderType
        fileDialog.chooseMode = FilesDialog.IndividualChoice
        fileDialog.exec(utility.homePath(), FilesDialog.Dirs|FilesDialog.Drives)
        if(fileDialog.selectionCount>0){
            return fileDialog.firstSelection()
        }

        return null
    }

    tools: MyToolBarLayout{
        MyToolIcon{
            invertedTheme: command.style.toolBarInverted
            iconId: "toolbar-back"
            onClicked: {
                pageStack.pop()
            }
        }
    }

    HeaderView{
        id: header

        textColor: command.style.newsContentFontColor
        font.pixelSize: command.style.metroTitleFontPixelSize
        title: qsTr("Settings")
        height: screen.currentOrientation===Screen.Portrait?72:56
    }

    Flickable{
        id:settingFlick

        anchors{
            top: header.bottom
            bottom: parent.bottom
            bottomMargin: command.style.penetrateToolBar?
                              -main.pageStack.toolBar.height:0
        }
        width: parent.width
        clip: true

        contentHeight: logo.height+textVersion.implicitHeight+checkForUpdateButton.height+950

        Behavior on contentY{
            NumberAnimation{duration: 200}
        }


        Image{
            id:logo

            y: 20
            source: "qrc:/images/logo.svg"
            sourceSize.width: 140
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text{
            id:textVersion

            text: qsTr("Version:")+utility.appVersion
            color: command.style.newsContentFontColor
            font.pixelSize: 22
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: logo.bottom
            anchors.topMargin: 10
        }

        CuttingLine{
            id:divide1

            textColor: command.style.inactiveFontColor
            annotation: qsTr("General settings")

            anchors.top: textVersion.bottom
            anchors.topMargin: 10
            width: parent.width-20
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MySwitch{
            id:show_image_off_on

            textColor: command.style.newsContentFontColor

            enabled: !wifi_load_image.checked
            checked: command.noPicturesMode
            anchors.top: divide1.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            switch_text: qsTr("No pictures mode")

            KeyNavigation.up: signature_input
            KeyNavigation.down: wifi_load_image
        }
        MySwitch{
            id:wifi_load_image

            textColor: command.style.newsContentFontColor

            enabled: !show_image_off_on.checked
            checked: command.wifiMode
            anchors.top: show_image_off_on.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            switch_text: qsTr("Load pictures only with WIFI")

            KeyNavigation.up: show_image_off_on
            KeyNavigation.down: full_screen
        }
        MySwitch{
            id:full_screen

            textColor: command.style.newsContentFontColor

            checked: command.fullscreenMode
            anchors.top: wifi_load_image.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            switch_text: qsTr("Fullscreen when sliding")

            KeyNavigation.up: wifi_load_image
            KeyNavigation.down: titleFontSize
        }
        MySwitch{
            id:auto_updata_app

            textColor: command.style.newsContentFontColor

            checked: command.checkUpdate
            anchors.top: full_screen.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            switch_text: qsTr("Automatic check for updates")

            KeyNavigation.up: full_screen
            KeyNavigation.down: titleFontSize
        }


        CuttingLine{
            id:cut_off

            textColor: command.style.inactiveFontColor

            anchors.top: auto_updata_app.bottom
            anchors.topMargin: 10
            width: parent.width-20
            anchors.horizontalCenter: parent.horizontalCenter
            annotation: qsTr("Font pixel size")
        }

        Text{
            id: textReference1

            anchors.top: cut_off.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Reference Text")
            font.pixelSize: titleFontSize.value
            color: command.style.newsContentFontColor
        }

        MySlider {
            id: titleFontSize

            value: command.newsTitleFontSize

            anchors.top: textReference1.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            sliderText: qsTr("Title      ")
            maximumValue: 28
            minimumValue: 18
            textColor: command.style.newsContentFontColor
            stepSize: 1
            KeyNavigation.up: auto_updata_app
            KeyNavigation.down: contentFontSize
        }

        Text{
            id: textReference2

            anchors.top: titleFontSize.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Reference Text")
            font.pixelSize: contentFontSize.value
            color: command.style.newsContentFontColor
        }

        MySlider {
            id: contentFontSize

            value: command.newsContentFontSize

            anchors.top: textReference2.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            sliderText: qsTr("Content")
            maximumValue: 30
            minimumValue: 20
            textColor: command.style.newsContentFontColor
            stepSize: 1
            KeyNavigation.up: titleFontSize
            KeyNavigation.down: selectionListItem
        }

        CuttingLine{
            id:cut_off2

            textColor: command.style.inactiveFontColor
            annotation: qsTr("Images save path")

            anchors.top: contentFontSize.bottom
            anchors.topMargin: 10
            width: parent.width-20
            anchors.horizontalCenter: parent.horizontalCenter
        }


        Text{
            id: imageSavePath

            text: command.imagesSavePath==""?qsTr("null"):command.imagesSavePath
            anchors.top: cut_off2.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            color: command.style.newsContentFontColor
            font.pixelSize: 22
            elide: Text.ElideMiddle
        }

        MouseArea{
            anchors.top: cut_off2.top
            anchors.bottom: imageSavePath.bottom
            width: parent.width
            onClicked: {
                var path = selectPath()
                if(path){
                    imageSavePath.text = path.filePath
                }
            }
        }

        /*CuttingLine{
            id:cut_off3

            textColor: command.style.inactiveFontColor
            annotation: qsTr("Background Image path")

            anchors.top: imageSavePath.bottom
            anchors.topMargin: 10
            width: parent.width-20
            anchors.horizontalCenter: parent.horizontalCenter
        }*/


        CuttingLine{
            id:cut_off4

            textColor: command.style.inactiveFontColor
            annotation: qsTr("Preferences settings")

            anchors.top: imageSavePath.bottom
            anchors.topMargin: 10
            width: parent.width-20
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ToolButton{
            id: selectionListItem

            anchors.top: cut_off4.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 20

            KeyNavigation.up: contentFontSize
            KeyNavigation.down: signature_input

            platformStyle: ToolButtonStyle{
                backgroundVisible: !selectionListItem.flat
                inverted: command.style.selectionThemeButtonInverted!=true
                textColor: command.style.newsContentFontColor
            }
            onClicked: {
                selectionDialog.open()
            }

            MySelectionDialog{
                id: selectionDialog

                selectedIndex: -1
                model: ListModel{
                    Component.onCompleted: {
                        var theme_list = command.getThemeList()
                        for(var i in theme_list){
                            var theme_name = theme_list[i]
                            append({"name": theme_name})
                            if(theme_name == command.theme){
                                selectionDialog.selectedIndex = i
                            }
                        }
                    }
                }

                onSelectedIndexChanged: {
                    var temp_obj = selectionDialog.model.get(selectionDialog.selectedIndex)
                    if(temp_obj)
                        selectionListItem.text = qsTr("Theme: ")+temp_obj.name
                    else
                        selectionListItem.text = qsTr("Theme: ")

                    command.theme = temp_obj.name
                }
            }

            Image {
                id: indicator
                source: command.getIconSource(command.style.selectionThemeButtonInverted, "indicator", "svg", true)
                anchors {
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        TextField{
            id: signature_input

            placeholderText: command.signature==""?qsTr("Signature"):command.signature
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: selectionListItem.bottom
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 20

            KeyNavigation.up: selectionListItem
            KeyNavigation.down: show_image_off_on
        }

        CuttingLine{
            id: cut_off5

            textColor: command.style.inactiveFontColor

            anchors.top: signature_input.bottom
            anchors.topMargin: 20
            width: parent.width-20
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MyButton{
            id: checkForUpdateButton

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: cut_off5.bottom
            anchors.topMargin: 10
            text: qsTr("Check for updates")
            width: parent.width*0.6

            function checkUpdate() {
                function onCheckFinished(error, data) {
                    if (error) {
                        return;
                    }

                    data = JSON.parse(data);

                    if (data.error) {
                        command.showBanner(data.error);
                        return;
                    }

                    if (data.app.version && data.app.version != utility.appVersion) {
                        command.showBanner(qsTr("Found a new version: %1, Please go to 9Store download").replace("%1", data.app.version));
                    } else {
                        command.showBanner(qsTr("Already the latest version"));
                    }
                }

                Server.getAppInfoById("586af64ede24789fdf8ae478", onCheckFinished);
            }

            Component.onCompleted: {
                checkUpdate();
            }

            onClicked: {
                checkUpdate();
            }
        }
    }

    Component.onDestruction: {
        command.noPicturesMode = show_image_off_on.checked
        command.wifiMode = wifi_load_image.checked
        command.fullscreenMode = full_screen.checked
        command.checkUpdate = auto_updata_app.checked
        command.newsTitleFontSize = titleFontSize.value
        command.newsContentFontSize = contentFontSize.value
        command.signature = signature_input.text
        if(imageSavePath.text!=qsTr("null")){
            command.imagesSavePath = imageSavePath.text
        }
    }
}
