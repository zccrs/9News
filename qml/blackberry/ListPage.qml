import bb.cascades 1.2
Page{
    id:listpage;
    content: Container {


    } // end of Container
    actions: [
        ActionItem {
            title: "Next page"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                var page = pageDefinition.createObject();
                navigationPane.push(page);
            }

            attachedObjects: ComponentDefinition {
                id: pageDefinition;
                source: "NewsPage.qml"
            }
        }
    ]
}

