TARGET = 9News

CONFIG += mobility
MOBILITY += systeminfo

QML_IMPORT_PATH =
INCLUDEPATH += src

#General
folder_02.source = qml/utility
folder_02.target = qml
#js
folder_03.source = qml/js
folder_03.target = qml

#Symbian
symbian{
    QT += webkit

    TARGET.UID3 = 0xE2E87DAE
    TARGET.CAPABILITY += NetworkServices

    #Symbian qml files
    folder_01.source = qml/symbian
    folder_01.target = qml
    folder_04.source = theme_symbian
    folder_04.target = ./
    DEPLOYMENTFOLDERS += folder_01 folder_02 folder_03 folder_04

    #Symbian resource files
    RESOURCES += symbian.qrc
}

#Meego
contains(MEEGO_EDITION, harmattan){
    QT += webkit

    CONFIG += qdeclarative-boostable

    #Meego qml files
    folder_01.source = qml/meego
    folder_01.target = qml
    folder_04.source = theme_meego
    folder_04.target = ./
    DEPLOYMENTFOLDERS += folder_01 folder_02 folder_03 folder_04

    OTHER_FILES += \
        qtc_packaging/debian_harmattan/rules \
        qtc_packaging/debian_harmattan/README \
        qtc_packaging/debian_harmattan/manifest.aegis \
        qtc_packaging/debian_harmattan/copyright \
        qtc_packaging/debian_harmattan/control \
        qtc_packaging/debian_harmattan/compat \
        qtc_packaging/debian_harmattan/changelog

    #Meego resource files
    RESOURCES += meego.qrc
}

#Blackberry
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

#Sailfish
contains(QT_VERSION,5.1.0){
    DEFINES += Q_OS_SAILFISH


}

#Symbian and meego simulator
simulator{
    QT += webkit

    folder_01.source = qml
    folder_01.target = ./
    folder_04.source = theme_symbian
    folder_04.target = ./
    DEPLOYMENTFOLDERS += folder_01 folder_04

    RESOURCES += symbian.qrc
}

#General src files
SOURCES += \
    src/main.cpp \
    src/ncommand.cpp
HEADERS += \
    src/ncommand.h

#General resource files
RESOURCES += \
    images.qrc \
    theme.qrc

#sub-item
include(src/utility/utility.pri)
include(src/selectfilesdialog/selectfilesdialog.pri)
include(src/mywidgets/mywidgets.pri)
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()



