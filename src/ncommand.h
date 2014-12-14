#ifndef NCOMMAND_H
#define NCOMMAND_H

#include <QObject>
#include <QVariant>
#include <QUrl>

class Utility;
class NCommand : public QObject
{
    Q_OBJECT
    Q_PROPERTY(SystemType systemType READ systemTye CONSTANT)
    //当前系统类型
    Q_PROPERTY(bool invertedTheme READ invertedTheme WRITE setInvertedTheme NOTIFY invertedThemeChanged)
    //是否是反色主题
    Q_PROPERTY(QVariantMap style READ style CONSTANT)
    //记录qml界面某些控件的属性，例如Text的字体大小和颜色等等
    Q_PROPERTY(int newsContentFontSize READ newsContentFontSize WRITE setNewsContentFontSize NOTIFY newsContentFontSizeChanged)
    //记录新闻内容字体大小的设置
    Q_PROPERTY(int newsTitleFontSize READ newsTitleFontSize WRITE setNewsTitleFontSize NOTIFY newsTitleFontSizeChanged)
    //记录新闻标题字体的大小
    Q_PROPERTY(bool noPicturesMode READ noPicturesMode WRITE setNoPicturesMode NOTIFY noPicturesModeChanged)
    //无图模式
    Q_PROPERTY(bool wifiMode READ wifiMode WRITE setWifiMode NOTIFY wifiModeChanged)
    //仅wifi下加载图片模式
    Q_PROPERTY(QString signature READ signature WRITE setSignature NOTIFY signatureChanged)
    //发布评论时的小尾巴
    Q_PROPERTY(bool fullscreenMode READ fullscreenMode WRITE setFullscreenMode NOTIFY fullscreenModeChanged)
    //滑动时是否全屏（是否隐藏工具栏）
    Q_PROPERTY(bool checkUpdate READ checkUpdate WRITE setCheckUpdate NOTIFY checkUpdateChanged)
    //是否自动检测更新
    Q_PROPERTY(QString imagesSavePath READ imagesSavePath WRITE setImagesSavePath NOTIFY imagesSavePathChanged)
    //下载图片的保存地址
    Q_PROPERTY(QString backgroundImage READ backgroundImage WRITE setBackgroundImage NOTIFY backgroundImageChanged)
    //程序背景图的路径

    Q_ENUMS(SystemType)

public:
    explicit NCommand(QObject *parent = 0);
    
    enum SystemType{
        Symbian,
        Harmattan
    };

    SystemType systemTye() const;
    bool invertedTheme() const;
    QVariantMap style() const;
    int newsContentFontSize() const;
    int newsTitleFontSize() const;
    bool noPicturesMode() const;
    bool wifiMode() const;
    QString signature() const;
    bool fullscreenMode() const;
    bool checkUpdate() const;
    QString imagesSavePath() const;
    QString backgroundImage() const;

signals:
    void invertedThemeChanged(bool arg);
    void getNews(int newsId, const QString& title);
    //发送信号告诉qml端用户要阅读第新闻Id为newsId的新闻,title是新闻标题
    void newsContentFontSizeChanged(int arg);
    void newsTitleFontSizeChanged(int arg);
    void showBanner(const QString& message);
    void noPicturesModeChanged(bool arg);
    void wifiModeChanged(bool arg);
    void signatureChanged(QString arg);
    void fullscreenModeChanged(bool arg);
    void checkUpdateChanged(bool arg);
    void imagesSavePathChanged(QString arg);
    void backgroundImageChanged(QString arg);

public slots:
    void setInvertedTheme(bool arg);
    QString fromTime_t ( uint seconds ) const;
    void setNewsContentFontSize(int arg);
    void setNewsTitleFontSize(int arg);
    QUrl getIconSource(const QString& iconName, bool invertedTheme) const;
    //返回ToolButton中自定义图标的url。例如iconName为skin，则返回"qrc:/images/skin.png"
    void setNoPicturesMode(bool arg);
    void setWifiMode(bool arg);
    void setSignature(QString arg);
    void setFullscreenMode(bool arg);
    void setCheckUpdate(bool arg);
    void setImagesSavePath(QString arg);
    void setBackgroundImage(QString arg);

private:
    bool m_invertedTheme;
    QVariantMap m_style;
    int m_newsContentFontSize;
    int m_newsTitleFontSize;
    Utility* utility;
    bool m_noPicturesMode;
    bool m_wifiMode;
    QString m_signature;
    bool m_fullscreenMode;
    bool m_checkUpdate;
    QString m_imagesSavePath;
    QString m_backgroundImage;
};

#endif // NCOMMAND_H
