// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../../js/configure.js" as ConfigureScript

Text{
    id: root
    property int fontSize: ConfigureScript.style.metroTitleFontPointSize

    text: title
    anchors.verticalCenter: parent.verticalCenter
    opacity: 1-Math.abs(currentPageIndex-index)/10

    color: {
        if(currentPageIndex==index){
            return command.invertedTheme?"black":"white"
        }else{
            return command.invertedTheme?"#666":"#ddd"
        }
    }

    font{
        bold: currentPageIndex == index
        pointSize: {
            var deviations = Math.abs(currentPageIndex-index)
            if(deviations<4)
                return fontSize - deviations*2
            else
                return 3
        }
    }
}
