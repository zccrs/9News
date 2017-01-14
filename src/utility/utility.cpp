#include "utility.h"
#include <QDebug>
#include <QtCore>
#include <QApplication>
#include <QTimer>
#include "mynetworkaccessmanagerfactory.h"
#include "downloadimage.h"
#include "myhttprequest.h"

Utility *Utility::me=NULL;
Utility *Utility::createUtilityClass()
{
    if(me==NULL){
        if(me==NULL){
            me = new Utility();
        }
    }

    return me;
}

Utility::Utility(QObject *parent) :
    QObject(parent)
{
    qmlRegisterUncreatableType<Utility>("utility", 1, 0, "Utility", "Error,Utility Cannot be instantiated!");

    http_request = new MyHttpRequest(this);
    download_image = new DownloadImage(this);
}

Utility::~Utility()
{
}

void Utility::consoleLog(QString str)
{
    qDebug()<<"c++:"+str;
}

QString Utility::getCookie(QString cookieName)
{
    QList<QNetworkCookie> temp = NetworkCookieJar::GetInstance ()->cookies ();
    foreach( QNetworkCookie cookie, temp ) {
        if( cookie.name () == cookieName)
            return cookie.value ();
    }
    return "";
}

QString Utility::fromUtf8(const QByteArray &data) const
{
    return QString::fromUtf8(data);
}

#if(QT_VERSION>=0x050000)
QQmlApplicationEngine *Utility::qmlEngine()
#else
QDeclarativeEngine *Utility::qmlEngine()
#endif
{
    return engine;
}

MyHttpRequest *Utility::getHttpRequest()
{
    return http_request;
}

DownloadImage *Utility::getDownloadImage()
{
    return download_image;
}

bool Utility::networkIsOnline() const
{
    return networkConfigurationManager.isOnline ();
}

QString Utility::appVersion() const
{
    return qApp->applicationVersion();
}

#if(QT_VERSION>=0x050000)
void Utility::setQmlEngine(QQmlApplicationEngine *new_engine)
{
    engine = new_engine;
    if(engine){
        engine->rootContext ()->setContextProperty ("utility", this);
    }
}

void Utility::initUtility(QSettings *settings, QQmlApplicationEngine *qmlEngine)
{
    setQSettings (settings);
    setQmlEngine (qmlEngine);
}
#else
void Utility::setQmlEngine(QDeclarativeEngine *new_engine)
{
    engine = new_engine;
    if(engine){
        engine->rootContext ()->setContextProperty ("utility", this);
    }
}

void Utility::initUtility(QSettings *settings, QDeclarativeEngine *qmlEngine)
{
    setQSettings (settings);
    setQmlEngine (qmlEngine);
}
#endif

void Utility::setQSettings(QSettings *settings)
{
    if(settings)
        mysettings = settings;
}

void Utility::setValue(const QString &key, const QVariant &value)
{
    if( mysettings )
        mysettings->setValue (key, value);
    else
        qDebug()<<"mysetting=NULL";
}

QVariant Utility::value(const QString &key, const QVariant &defaultValue) const
{
    if( mysettings )
        return mysettings->value (key, defaultValue);
    else{
        qDebug()<<"mysetting=NULL";
        return QVariant("");
    }
}

void Utility::removeValue(const QString &key)
{
    if( mysettings )
        mysettings->remove (key);
    else
        qDebug()<<"mysetting=NULL";
}

#if(QT_VERSION>=0x050000)
void Utility::downloadImage(QJSValue callbackFun, QUrl url, QString savePath, QString saveName)
{
    download_image->getImage (callbackFun, url, savePath, saveName);
}

void Utility::httpGet(QJSValue callbackFun, QUrl url, bool highRequest)
{
    http_request->get (callbackFun, url, highRequest);
}

void Utility::httpPost(QJSValue callbackFun, QUrl url, QByteArray data, bool highRequest)
{
    http_request->post (callbackFun, url, data, highRequest);
}
#else
void Utility::downloadImage(QScriptValue callbackFun, QUrl url, QString savePath, QString saveName)
{
    download_image->getImage (callbackFun, url, savePath, saveName);
}

void Utility::httpGet(QScriptValue callbackFun, QUrl url, bool highRequest)
{
    http_request->get (callbackFun, url, highRequest);
}

void Utility::httpPost(QScriptValue callbackFun, QUrl url, QByteArray data, bool highRequest)
{
    http_request->post (callbackFun, url, data, highRequest);
}
#endif
void Utility::downloadImage(QObject *caller, QByteArray slotName, QUrl url, QString savePath, QString saveName)
{
    download_image->getImage (caller, slotName, url, savePath, saveName);
}

void Utility::httpGet(QObject *caller, QByteArray slotName, QUrl url, bool highRequest)
{
    http_request->get (caller, slotName, url, highRequest);
}

void Utility::httpPost(QObject *caller, QByteArray slotName, QUrl url, QByteArray data, bool highRequest)
{
    http_request->post (caller, slotName, url, data, highRequest);
}

void Utility::socketAbort()
{
    http_request->abort ();
}

void Utility::setNetworkProxy(int type, QString location, QString port, QString username, QString password)
{
    QNetworkProxy proxy;
    proxy.setType((QNetworkProxy::ProxyType)type);
    proxy.setHostName(location);
    proxy.setPort(port.toUShort ());
    proxy.setUser (username);
    proxy.setPassword (password);
    QNetworkProxy::setApplicationProxy(proxy);
}

QString Utility::stringEncrypt(const QString &content, QString key)
{
    if (content.isEmpty() || key.isEmpty())
        return content;

    key = QString::fromUtf8(QCryptographicHash::hash(key.toUtf8(), QCryptographicHash::Md5));

    QString request;

    for (int i = 0; i < content.count(); ++i) {
        request.append(QChar(content.at(i).unicode() ^ key.at(i % key.size()).unicode()));
    }

    return request;
}

QString Utility::stringUncrypt(const QString &content, QString key)
{
    return stringEncrypt(content, key);
}

bool myRemovePath(QString dirPath, bool deleteHidden, bool deleteSelf)
{
    qDebug()<<"removePath的进程"<<QThread::currentThread ();
    QDir entry (dirPath);
    if(!entry.exists()||!entry.isReadable())
        return false;
    entry.setFilter(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot | QDir::Hidden);
    QFileInfoList dirList = entry.entryInfoList();
    bool bHaveHiddenFile = false;

    if(!dirList.isEmpty()) {
        for( int i = 0; i < dirList.size() ; ++i) {
            QFileInfo info = dirList.at(i);
            if(info.isHidden() && !deleteHidden) {
                bHaveHiddenFile = true;
                continue;
            }
            QString path = info.absoluteFilePath();
            if(info.isDir()) {
                if(!myRemovePath(path, deleteHidden, true))
                    return false;
            }else if(info.isFile()) {
                if(!QFile::remove(path))
                    return false;
            }else
                return false;
        }
    }

    if(deleteSelf && !bHaveHiddenFile) {
        if(!entry.rmdir(dirPath)) {
            return false;
        }
    }
    return true;
}

void Utility::removePath(QString dirPath, bool deleteHidden/*=false*/, bool deleteSelf/*=true*/)
{
    qDebug()<<"removePath的调用进程"<<QThread::currentThread ();
#ifndef Q_OS_SYMBIAN
    QtConcurrent::run(myRemovePath, dirPath, deleteHidden, deleteSelf);
#endif
}

QString Utility::homePath() const
{
    return QDir::homePath();
}
