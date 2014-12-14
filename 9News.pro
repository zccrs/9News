TARGET = 9News

# Add more folders to ship with the application, here

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =C:/bbndk/target_10_3_1_995/qnx6/x86/usr/lib/qt4/imports/bb/cascades

INCLUDEPATH += src

folder_02.source = qml/utility
folder_02.target = qml
folder_03.source = qml/js
folder_03.target = qml

symbian{
    contains(QT_VERSION, 4.7.3){
        DEFINES += Q_OS_S60V5
        folder_01.source = qml/symbian1
#        RESOURCES += Symbian1-res.qrc
    } else {
        folder_01.source = qml/symbian
#        RESOURCES += Symbian3-res.qrc
    }
    folder_01.target = qml
    DEPLOYMENTFOLDERS += folder_01 folder_02 folder_03

    TARGET.UID3 = 0xE2E87DAE
    TARGET.CAPABILITY += NetworkServices

    RESOURCES += symbian.qrc

    vendorinfo = "%{\"9Smart\"}" ":\"9Smart\""
    my_deployment.pkg_prerules += vendorinfo
    DEPLOYMENT.display_name = 久闻
    DEPLOYMENT += my_deployment

#    CONFIG += localize_deployment
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
<<<<<<< HEAD
    src/ncommand.h \

DISTFILES += \
    qml/blackberry/ListPage.qml

OTHER_FILES += \
    qml/blackberry/NewsPage.qml
=======
    src/ncommand.h
>>>>>>> dev_AfterTheRainOfStars
