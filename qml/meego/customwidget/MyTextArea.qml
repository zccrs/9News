// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import com.nokia.meego 1.1

TextArea{
    onImplicitHeightChanged: {
        height = Math.max(52, implicitHeight)
    }
}
