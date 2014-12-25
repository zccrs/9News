import QtQuick 1.0
import com.nokia.symbian 1.1

QtObject {
    id: constants;

    // UI - Graphic size
    property int headerHeight: 60;

    // UI - Margins
    property real headerTitleLeftMargin: 15;

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
