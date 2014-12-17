#ifndef NCOMMAND_H
#define NCOMMAND_H

#include <QObject>
#include <QVariant>
#include <QUrl>
#include <QSettings>

class Utility;
class NCommand : public QObject
{
    Q_OBJECT
    Q_PROPERTY(SystemType systemType READ systemTye CONSTANT)
    //当前系统类型
    Q_PROPERTY(QVariantMap style READ style NOTIFY styleChanged FINAL)
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
    Q_PROPERTY(QString theme READ theme WRITE setTheme NOTIFY themeChanged)
    //记录当前主题

    Q_ENUMS(SystemType)

public:
    explicit NCommand(QObject *parent = 0);
    
    enum SystemType{
        Symbian,
        Harmattan
    };

    SystemType systemTye() const;
    QVariantMap style() const;
    int newsContentFontSize() const;
    int newsTitleFontSize() const;
    bool noPicturesMode() const;
    bool wifiMode() const;
    QString signature() const;
    bool fullscreenMode() const;
    bool checkUpdate() const;
    QString imagesSavePath() const;
    QString theme() const;

signals:
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
    void styleChanged(QVariantMap arg);
    void themeChanged(QString arg);

public slots:
    QString fromTime_t ( uint seconds ) const;
    void setNewsContentFontSize(int arg);
    void setNewsTitleFontSize(int arg);
    QUrl getIconSource(QVariant invertedTheme, const QString &iconName,
                       const QString &format="svg", bool utility=false) const;
    //返回ToolButton中自定义图标的url。例如iconName为skin，则返回"qrc:/images/skin.png"
    void setNoPicturesMode(bool arg);
    void setWifiMode(bool arg);
    void setSignature(QString arg);
    void setFullscreenMode(bool arg);
    void setCheckUpdate(bool arg);
    void setImagesSavePath(QString arg);
    void themeSwitch();
    void setTheme(const QString& arg);
    bool setTheme(int index);
    QVariantList themesName() const;

private:
    struct ThemeInfo{
        QString filePath;
        QString themeName;
        ThemeInfo(){}
        ThemeInfo(const QString& path, const QString name)
        {
            filePath = path;
            themeName = name;
        }
    };

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
    QString m_theme;
    QList<ThemeInfo> themeList;
    int currentThemeIndex;//记录当前使用的是第几个主题

    void getCustomThemeList();
    void setStyleProperty(const QString &name, const QSettings &settings, const QVariant defaultValue);
    void updateStyle(const QSettings& settings);
};

#endif // NCOMMAND_H
