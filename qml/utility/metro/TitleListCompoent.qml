// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Text{
    id: root
    property int fontSize: command.style.metroTitleFontPointSize

    text: title
    anchors.verticalCenter: parent.verticalCenter
    opacity: 1-Math.abs(ListView.view.currentIndex-index)/10

    color: {
        if(ListView.isCurrentItem){
            return command.invertedTheme?"black":"white"
        }else{
            return command.invertedTheme?"#666":"#ddd"
        }
    }

    font{
        bold: ListView.isCurrentItem
        pointSize: {
            var deviations = Math.abs(ListView.view.currentIndex-index)
            if(deviations<4)
                return fontSize - deviations*2
            else
                return fontSize-6
        }
    }
}
