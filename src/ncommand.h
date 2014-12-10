#ifndef NCOMMAND_H
#define NCOMMAND_H

#include <QObject>
#include <QVariant>
#include <QUrl>

class NCommand : public QObject
{
    Q_OBJECT
    Q_PROPERTY(SystemType systemType READ systemTye CONSTANT)
    Q_PROPERTY(bool invertedTheme READ invertedTheme WRITE setInvertedTheme NOTIFY invertedThemeChanged)
    Q_PROPERTY(QVariantMap style READ style CONSTANT)
    //记录qml界面某些控件的属性，例如Text的字体大小和颜色等等
    Q_PROPERTY(int newsContentFontSize READ newsContentFontSize WRITE setNewsContentFontSize NOTIFY newsContentFontSizeChanged)
    //记录新闻内容字体大小的设置
    Q_PROPERTY(int newsTitleFontSize READ newsTitleFontSize WRITE setNewsTitleFontSize NOTIFY newsTitleFontSizeChanged)
    //记录新闻标题字体的大小

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


signals:
    void invertedThemeChanged(bool arg);
    void getNews(int newsId, const QString& title);
    //发送信号告诉qml端用户要阅读第新闻Id为newsId的新闻,title是新闻标题
    void newsContentFontSizeChanged(int arg);
    void newsTitleFontSizeChanged(int arg);

public slots:
    void setInvertedTheme(bool arg);
    QString fromTime_t ( uint seconds ) const;
    QString textToHtml(const QString& text, int width) const;
    void setNewsContentFontSize(int arg);
    void setNewsTitleFontSize(int arg);
    QUrl getIconSource(const QString& iconName, bool invertedTheme) const;
    //返回ToolButton中自定义图标的url。例如iconName为skin，则返回"qrc:/images/skin.png"
private:
    bool m_invertedTheme;
    QVariantMap m_style;
    int m_newsContentFontSize;
    int m_newsTitleFontSize;
};

#endif // NCOMMAND_H
