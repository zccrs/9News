TARGET = 9News

CONFIG += mobility
MOBILITY += systeminfo

QML_IMPORT_PATH =
INCLUDEPATH += src

<<<<<<< HEAD
#通用qml组件文件
=======
#General
>>>>>>> dev_AfterTheRainOfStars
folder_02.source = qml/utility
folder_02.target = qml
#js文件
folder_03.source = qml/js
folder_03.target = qml

<<<<<<< HEAD
#Symbian平台相关
=======
#Symbian
>>>>>>> dev_AfterTheRainOfStars
symbian{
    QT += webkit

    TARGET.UID3 = 0xE2E87DAE
    TARGET.CAPABILITY += NetworkServices

<<<<<<< HEAD
    #Symbian平台qml文件
=======
    #Symbian qml files
>>>>>>> dev_AfterTheRainOfStars
    folder_01.source = qml/symbian
    folder_01.target = qml
    folder_04.source = theme_symbian
    folder_04.target = ./
    DEPLOYMENTFOLDERS += folder_01 folder_02 folder_03 folder_04

<<<<<<< HEAD
    #Symbian平台资源文件
    RESOURCES += symbian.qrc
}

#Meego平台相关
=======
    #Symbian resource files
    RESOURCES += symbian.qrc
}

#Meego
>>>>>>> dev_AfterTheRainOfStars
contains(MEEGO_EDITION, harmattan){
    QT += webkit

    CONFIG += qdeclarative-boostable

<<<<<<< HEAD
    #Meego平台qml文件
=======
    #Meego qml files
>>>>>>> dev_AfterTheRainOfStars
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

<<<<<<< HEAD
    #Meego平台资源文件
    RESOURCES += meego.qrc
}

#Blackberry平台相关
=======
    #Meego resource files
    RESOURCES += meego.qrc
}

#Blackberry
>>>>>>> dev_AfterTheRainOfStars
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

<<<<<<< HEAD
#Sailfish平台相关
=======
#Sailfish
>>>>>>> dev_AfterTheRainOfStars
contains(QT_VERSION,5.1.0){
    DEFINES += Q_OS_SAILFISH


}

<<<<<<< HEAD
#Symbian和meego平台模拟器相关
=======
#Symbian and meego simulator
>>>>>>> dev_AfterTheRainOfStars
simulator{
    QT += webkit

    folder_01.source = qml
    folder_01.target = ./
    folder_04.source = theme_symbian
    folder_04.target = ./
    DEPLOYMENTFOLDERS += folder_01 folder_04

    RESOURCES += symbian.qrc
}

<<<<<<< HEAD
#公共源文件和头文件
=======
#General src files
>>>>>>> dev_AfterTheRainOfStars
SOURCES += \
    src/main.cpp \
    src/ncommand.cpp
HEADERS += \
    src/ncommand.h

<<<<<<< HEAD
#公用资源文件
=======
#General resource files
>>>>>>> dev_AfterTheRainOfStars
RESOURCES += \
    images.qrc \
    theme.qrc

<<<<<<< HEAD
#子项目
=======
#sub-item
>>>>>>> dev_AfterTheRainOfStars
include(src/utility/utility.pri)
include(src/selectfilesdialog/selectfilesdialog.pri)
include(src/mywidgets/mywidgets.pri)
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
<<<<<<< HEAD
#include(src/yeatse/yeatse.pri)
=======
>>>>>>> dev_AfterTheRainOfStars



