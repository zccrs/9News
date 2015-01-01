import QtQuick 1.0
import com.nokia.symbian 1.1

QtObject {
    id: constants;

    // Version
    property string version: "0.0.1";

    // UI - Graphic size
    property int headerHeight: 60;
    property int busyIndicatorSizeSmall: 40;
    property int busyIndicatorSizeMedium: 70;
    property int busyIndicatorSizeLarge: 10;

    // UI - Margins
    property real headerTitleLeftMargin: 15;
    property real marginSmall: 5;
    property real marginMedium: 10;
    property real marginLarge: 20;

    // UI - Mask Opacity
    property real maskOpacity: 0.6;

    // Animation - Duration
    property int animationDurationFast: 100;
    property int animationDurationNormal: 300;
    property int animationDurationSlow: 500;

    // color
    //property color colorLight: platformStyle.colorNormalLight;
    //property color colorMid: platformStyle.colorNormalMid;
    //property color colorMarginLine: platformStyle.colorDisabledMid;
    //property color colorTextSelection: platformStyle.colorTextSelection;
    //property color colorDisabled: platformStyle.colorDisabledMid;

    // font color
    //property color fontColorNormal: "White";

    // padding size
    //property int paddingSmall: platformStyle.paddingSmall
    //property int paddingMedium: platformStyle.paddingMedium
    //property int paddingLarge: platformStyle.paddingLarge
    //property int paddingXLarge: platformStyle.paddingLarge + platformStyle.paddingSmall

    // graphic size
    //property int graphicSizeTiny: platformStyle.graphicSizeTiny
    //property int graphicSizeSmall: platformStyle.graphicSizeSmall
    //property int graphicSizeMedium: platformStyle.graphicSizeMedium
    //property int graphicSizeLarge: platformStyle.graphicSizeLarge
    //property int thumbnailSize: platformStyle.graphicSizeLarge * 1.5

    // font size
    //property int fontXSmall: platformStyle.fontSizeSmall - 2
    //property int fontSmall: platformStyle.fontSizeSmall
    //property int fontMedium: platformStyle.fontSizeMedium
    //property int fontLarge: platformStyle.fontSizeLarge
    //property int fontXLarge: platformStyle.fontSizeLarge + 2
    //property int fontXXLarge: platformStyle.fontSizeLarge + 4

    // size
    //property variant sizeTiny: Qt.size(graphicSizeTiny, graphicSizeTiny);
    //property variant sizeMedium: Qt.size(graphicSizeMedium, graphicSizeMedium);

    // others
    //property int headerHeight: app.inPortrait ? privateStyle.tabBarHeightPortrait
    //                                          : privateStyle.tabBarHeightLandscape;
    //property string invertedString: tbsettings.whiteTheme ? "_inverted" : "";

}
