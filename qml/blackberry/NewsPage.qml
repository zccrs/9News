import bb.cascades 1.2

Page {
    content: Container {
        layout: DockLayout {}
        ImageView {
            // Use layout properties to center the image on the
            // screen
            layoutProperties: DockLayoutProperties {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }
            imageSource: "asset:///images/evil_smiley_small.png"

            animations: [
                // A translation animation that moves the image
                // downwards by a small amount
                TranslateTransition {
                    id: translateAnimation
                    toY: 150
                    duration: 1000
                },

                // A rotation animation that spins the image
                // by 180 degrees
                RotateTransition {
                    id: rotateAnimation
                    toAngleZ: 180
                    duration: 1000
                },

                // A scaling animation that increases the size
                // of the image by a factor of 2 in both the
                // x and y directions
                ScaleTransition {
                    id: scaleAnimation
                    toX: 2.0
                    toY: 2.0
                    duration: 1000
                }
            ]

            contextActions: [
                ActionSet {
                    title: "Animations"
                    subtitle: "Choose your animation"

                    // This action plays the translation animation
                    ActionItem {
                        title: "Slide"
                        imageSource: "asset:///images/slide_action.png"

                        onTriggered: {
                            translateAnimation.play();
                        }
                    }

                    // This action plays the rotation animation
                    ActionItem {
                        title: "Spin"
                        imageSource: "asset:///images/spin_action.png"

                        onTriggered: {
                            rotateAnimation.play();
                        }
                    }

                    // This action plays the scaling animation
                    ActionItem {
                        title: "Grow"
                        imageSource: "asset:///images/grow_action.png"

                        onTriggered: {
                            scaleAnimation.play();
                        }
                    }
                } // end of ActionSet
            ] // end of contextActions list
        } // end of ImageView
    } // end of Container
} // end of Page
