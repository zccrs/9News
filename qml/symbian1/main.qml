import QtQuick 1.0
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "Modules"

PageStackWindow {
    id: app;
    platformInverted: settings.invertedTheme;
    initialPage: mainPage;

    // Pages
    MainPage {
        id: mainPage;
    }

    // Modules
    SignalCenter {
        id: signalCenter;
    }
    Settings {
        id: settings;
    }
    Constants {
        id: constants;
    }

    // Components
    InfoBanner {
        id: infoBanner;
        timeout: 3000;
        interactive: false;
    }
    Timer {
        id: quitTimer;
        interval: 3000;
        repeat: false;
        running: false;
    }
}
