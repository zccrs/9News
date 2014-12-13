#include <QDateTime>
#include "ncommand.h"
#include "utility.h"

NCommand::NCommand(QObject *parent) :
    QObject(parent)
{
    m_invertedTheme = true;

    utility = Utility::createUtilityClass();

#ifdef HARMATTAN_BOOSTER
    m_style["metroTitleFontPointSize"] = 22;
    //Metro界面上方大标题的最大字体大小
    m_style["newsInfosFontPointSize"] = 10;
    //新闻列表中新闻来源和发表时间等新闻信息的字体大小
    m_style["flipchartsTitleFontPointSize"] = 10;
    //大海报上新闻标题的字体大小
    m_newsContentFontSize = utility->value("newsContentFontSize", 17).toInt();
    //新闻内容字体大小
    m_newsTitleFontSize = utility->value("newsTitleFontSize", 17).toInt();
    //新闻标题字体大小
#else
    m_style["metroTitleFontPointSize"] = 11;
    //Metro界面上方大标题的最大字体大小
    m_style["newsInfosFontPointSize"] = 5;
    //新闻列表中新闻来源和发表时间等新闻信息的字体大小
    m_style["flipchartsTitleFontPointSize"] = 5;
    //大海报上新闻标题的字体大小
    m_newsContentFontSize = utility->value("newsContentFontSize", 8).toInt();
    //新闻内容字体大小
    m_newsTitleFontSize = utility->value("newsTitleFontSize", 7).toInt();
    //新闻标题字体大小
#endif
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

QVariantMap NCommand::style() const
{
    return m_style;
}

int NCommand::newsContentFontSize() const
{
    return m_newsContentFontSize;
}

int NCommand::newsTitleFontSize() const
{
    return m_newsTitleFontSize;
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

void NCommand::setNewsContentFontSize(int arg)
{
    if (m_newsContentFontSize != arg) {
        m_newsContentFontSize = arg;
        utility->setValue("newsContentFontSize", arg);
        emit newsContentFontSizeChanged(arg);
    }
}

void NCommand::setNewsTitleFontSize(int arg)
{
    if (m_newsTitleFontSize != arg) {
        m_newsTitleFontSize = arg;
        utility->setValue("newsTitleFontSize", arg);
        emit newsTitleFontSizeChanged(arg);
    }
}

QUrl NCommand::getIconSource(const QString &iconName, bool invertedTheme) const
{
    QString source = "qrc:/images/"+iconName+(invertedTheme?"_invert.png":".png");
    return source;
}
