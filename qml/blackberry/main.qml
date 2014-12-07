import bb.cascades 1.2

NavigationPane {
    id: navigationPane

    // The initial page
    Page {
        content: Container {
            Button {
                text: "Display first Page"

                onClicked: {
                    navigationPane.push(firstPage);
                }
            }

            Button {
                text: "Display second Page"

                onClicked: {
                    navigationPane.push(secondPage);
                }
            }
        } // end of Container
    } // end of Page

    attachedObjects: [
        Page {
            id: firstPage
            content: Container {
                Label {
                    text: "First attachedObjects Page"
                }
            }
        },
        Page {
            id: secondPage
            content: Container {
                Label {
                    text: "Second attachedObjects Page"
                }
            }
        } // end of Page
    ] // end of attachedObjects list
} // end of NavigationPane
