#ifndef NCOMMAND_H
#define NCOMMAND_H

#include <QObject>

class NCommand : public QObject
{
    Q_OBJECT
    Q_PROPERTY(SystemType systemType READ systemTye CONSTANT)
    Q_PROPERTY(bool invertedTheme READ invertedTheme WRITE setInvertedTheme NOTIFY invertedThemeChanged)

    Q_ENUMS(SystemType)

public:
    explicit NCommand(QObject *parent = 0);
    
    enum SystemType{
        Symbian,
        Harmattan
    };

    SystemType systemTye() const;
    bool invertedTheme() const;

signals:
    void invertedThemeChanged(bool arg);
    void getNews(int newsId, const QString& title);
    //发送信号告诉qml端用户要阅读第新闻Id为newsId的新闻,title是新闻标题
public slots:
    void setInvertedTheme(bool arg);
    QString fromTime_t ( uint seconds ) const;
    QString textToHtml(const QString& text, int width, bool invertedTheme) const;
private:
    bool m_invertedTheme;
};

#endif // NCOMMAND_H
