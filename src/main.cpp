#include <QtGui/QApplication>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include <QDeclarativeComponent>
#include <QDebug>
#include <QSettings>
#include "qmlapplicationviewer.h"
#include "selectfilesdialog.h"
#include "ncommand.h"
#include "myimage.h"
#include "mysvgview.h"
#include "utility.h"
#include "myhttprequest.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    app->setApplicationName ("9News");
    app->setOrganizationName ("Stars");
    app->setApplicationVersion ("0.0.1");

#if defined(Q_WS_SIMULATOR)
    //模拟器下设置网络代理，测试用
    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::HttpProxy);
    proxy.setHostName("localhost");
    proxy.setPort(8888);
    QNetworkProxy::setApplicationProxy(proxy);
#endif

    qmlRegisterType<SelectFilesDialog>("com.stars.widgets", 1, 0, "FilesDialog");
    qmlRegisterType<MyImage>("com.stars.widgets", 1, 0, "MyImage");
    qmlRegisterType<MySvgView>("com.stars.widgets", 1, 0, "MySvgView");
    qmlRegisterType<NCommand>("com.news.utility", 1, 0, "NCommand");

    QmlApplicationViewer viewer;
    //viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);

    viewer.engine()->rootContext()->setContextProperty("fileDialog", new SelectFilesDialog());
    viewer.engine()->rootContext()->setContextProperty("command", new NCommand());

    QSettings settings;
    Utility *utility = Utility::createUtilityClass();
    utility->initUtility(&settings, viewer.engine());
    QNetworkRequest *httpRequest = utility->getHttpRequest()->getNetworkRequest();
    //httpRequest->setHeader(QNetworkRequest::ContentTypeHeader, "text/html,application/xhtml+xml");
    //httpRequest->setRawHeader("Accept-Encoding", "gzip");

#ifdef HARMATTAN_BOOSTER
    viewer.setMainQmlFile(QLatin1String("qml/meego/main.qml"));
#else
    viewer.setMainQmlFile(QLatin1String("qml/symbian/main.qml"));
#endif
    viewer.showExpanded();

    return app->exec();
}
