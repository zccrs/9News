// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import com.nokia.meego 1.1

BusyIndicator {
    platformStyle: BusyIndicatorStyle {
        period: 800
        size: "large"
        inverted: command.style.busyIndicatorInverted!=true
    }
}
