import bb.cascades 1.3
import "../js/api.js" as Api
Page{
    id:listpage;
    content: Container {
        ListView {
            dataModel: ArrayDataModel {
                id: theDataModel
            }
            listItemComponents: [
                            // The second ListItemComponent defines how "listItem" items
                            // should appear. These items use a Container that includes a
                            // CheckBox and a Label.
                            ListItemComponent {
                                type: "listItem"
                                Container {
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.LeftToRight
                                    }
                                    Label {
                                        text: ListItemData.topic

                                        // Apply a text style to create a title-sized font
                                        // with normal weight
                                        textStyle {
                                            base: SystemDefaults.TextStyles.TitleText
                                            fontWeight: FontWeight.Normal
                                        }
                                    }
                                }
                            }
                        ]
            function itemType(data, indexPath) {
                    return "listItem"
                }

            onCreationCompleted: {
                        utility.httpGet(getNewsListFinished, Api.getNewsUrlByCategory());
                        //去获取新闻分类
                    }
        }

    }
    titleBar: TitleBar {
        kind: TitleBarKind.Default;
        title :qsTr( "9News");
    }
    actions: [
        //RepeatPattern{}
        ActionItem{
            title: qsTr("Refresh");
            ActionBar.placement: ActionBarPlacement.Signature;
        },
        ActionItem {
            title: qsTr("Theme");
            ActionBar.placement: ActionBarPlacement.OnBar;
            onTriggered: {
                if (Application.themeSupport.theme.colorTheme.style == VisualStyle.Bright) {
                    Application.themeSupport.setVisualStyle(VisualStyle.Dark);
                }
                else {
                    Application.themeSupport.setVisualStyle(VisualStyle.Bright);
                }
            }
        },
        ActionItem{
            title: qsTr("All News");
            ActionBar.placement: ActionBarPlacement.InOverflow;
        },
        ActionItem{
            title: qsTr("Black Berry");
            ActionBar.placement: ActionBarPlacement.InOverflow;
        },
        ActionItem{
            title: qsTr("Firefox OS");
            ActionBar.placement: ActionBarPlacement.InOverflow;
        },
        ActionItem{
            title: qsTr("Meego");
            ActionBar.placement: ActionBarPlacement.InOverflow;
        },
        ActionItem{
            title: qsTr("Sailfish OS");
            ActionBar.placement: ActionBarPlacement.InOverflow;
        },
        ActionItem{
            title: qsTr("Tizen");
            ActionBar.placement: ActionBarPlacement.InOverflow;
        },
        ActionItem{
            title: qsTr("Ubuntu Touch");
            ActionBar.placement: ActionBarPlacement.InOverflow;
        },
        ActionItem{
            title: qsTr("Application");
            ActionBar.placement: ActionBarPlacement.InOverflow;
        }
    ]
    function getNewsListFinished(error, data){
            //当获取新闻种类结束后调用此函数
            if(error)//如果网络请求出错
                return

            data = JSON.parse(data)

            if(data.error===0){

                for(var i in data.articles)
                   { theDataModel.append(data.articles[i]);}

            }
        }
}

