import bb.cascades 1.3
Page{
    id:listpage;
    content: Container {


    }
    titleBar: TitleBar {
        kind: TitleBarKind.Default;
        title :qsTr( "9News");
    }
    actions: [
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
}

