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
        System,
        Harmattan
    };

    SystemType systemTye() const;
    bool invertedTheme() const;

signals:
    void invertedThemeChanged(bool arg);
    void getNews(int id);
    //发送信号告诉qml端用户要阅读第新闻Id为id的新闻
public slots:
    void setInvertedTheme(bool arg);
    QString fromTime_t ( uint seconds ) const;
private:
    bool m_invertedTheme;
};

#endif // NCOMMAND_H
