// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import com.nokia.meego 1.1

ScrollDecorator{
    platformStyle: ScrollDecoratorStyle{
        inverted: command.style.scrollBarInverted
    }
}
