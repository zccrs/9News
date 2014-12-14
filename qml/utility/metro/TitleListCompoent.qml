// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Text{
    id: root

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
    }

    scale:{
        var deviations = Math.abs(ListView.view.currentIndex-index)
        if(deviations<4)
            return 1-deviations/5
        else
            return 0.4
    }

    Behavior on scale{
        NumberAnimation{
            duration: 300
        }
    }
}
