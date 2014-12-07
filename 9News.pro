TARGET = 9News

# Add more folders to ship with the application, here

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

INCLUDEPATH += src

folder_02.source = qml/utility
folder_02.target = qml
folder_03.source = qml/js
folder_03.target = qml


symbian{
    TARGET.UID3 = 0xE2E87DAE
    TARGET.CAPABILITY += NetworkServices

    folder_01.source = qml/symbian
    folder_01.target = qml
    DEPLOYMENTFOLDERS += folder_01 folder_02 folder_03

    RESOURCES += symbian.qrc
}

contains(MEEGO_EDITION, harmattan){
    CONFIG += qdeclarative-boostable

    folder_01.source = qml/meego
    folder_01.target = qml
    DEPLOYMENTFOLDERS += folder_01 folder_02 folder_03

    OTHER_FILES += \
        qtc_packaging/debian_harmattan/rules \
        qtc_packaging/debian_harmattan/README \
        qtc_packaging/debian_harmattan/manifest.aegis \
        qtc_packaging/debian_harmattan/copyright \
        qtc_packaging/debian_harmattan/control \
        qtc_packaging/debian_harmattan/compat \
        qtc_packaging/debian_harmattan/changelog

    RESOURCES += meego.qrc
}
contains(QT_VERSION, 4.8.6){
    DEFINES += Q_OS_BLACKBERRY

    LIBS += -lbbdata -lbb -lbbcascades
    QT += declarative xml

    HEADERS += \
        src/blackberry/applicationui.h
    SOURCES += \
        src/blackberry/applicationui.cpp

    DISTFILES += \
        bar-descriptor.xml \
        qml/blackberry/main.qml
}

simulator{
    folder_01.source = qml
    folder_01.target = ./
    DEPLOYMENTFOLDERS += folder_01

    RESOURCES += symbian.qrc
}

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon


# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += \
    src/main.cpp \
    src/ncommand.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
include(src/utility/utility.pri)
include(src/selectfilesdialog/selectfilesdialog.pri)
include(src/mywidgets/mywidgets.pri)



RESOURCES += \
    images.qrc

HEADERS += \
    src/ncommand.h \
