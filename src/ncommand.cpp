#include "ncommand.h"
#include <QDateTime>

NCommand::NCommand(QObject *parent) :
    QObject(parent)
{
    m_invertedTheme = true;
}

NCommand::SystemType NCommand::systemTye() const
{
#ifdef HARMATTAN_BOOSTER
    return Harmattan;
#else
    return Symbian;
#endif
}

bool NCommand::invertedTheme() const
{
    return m_invertedTheme;
}

void NCommand::setInvertedTheme(bool arg)
{
    if (m_invertedTheme != arg) {
        m_invertedTheme = arg;
        emit invertedThemeChanged(arg);
    }
}

QString NCommand::fromTime_t(uint seconds) const
{
    return QDateTime::fromTime_t(seconds).toString(Qt::SystemLocaleDate);
}

QString NCommand::textToHtml(const QString &text, int width, bool invertedTheme) const
{
#ifdef HARMATTAN_BOOSTER
    if(invertedTheme)
        return "<html><style>*{padding:0;margin:0;}body{background-color:#000000;width:"+QString::number(width)+"px }</style><body>"+text+"</body></html>";
    else
        return "<html><style>*{padding:0;margin:0;}body{background-attachment:fixed;background-image: url(qrc:/images/meegoBackground.png);width:"+QString::number(width)+"px }</style><body>"+text+"</body></html>";
#else
    QString color = (invertedTheme?"#F1F1F1":"#000000");
    return "<html><style>*{padding:0;margin:0;}body{background-color:"+color+";width:"+QString::number(width)+"px}</style><body>"+text+"</body></html>";
#endif
}
