#include <QDateTime>
#include <QDebug>
#include "ncommand.h"
#include "utility.h"

NCommand::NCommand(QObject *parent) :
    QObject(parent)
{
    utility = Utility::createUtilityClass();

#ifdef HARMATTAN_BOOSTER
    m_style["metroTitleFontPixelSize"] = 32;
    //Metro界面上方大标题的最大字体大小
    m_style["newsInfosFontPixelSize"] = 16;
    //新闻列表中新闻来源和发表时间等新闻信息的字体大小
    m_style["flipchartsTitleFontPixelSize"] = 16;
    //大海报上新闻标题的字体大小
    m_newsContentFontSize = utility->value("newsContentFontSize", 26).toInt();
    //新闻内容字体大小
    m_newsTitleFontSize = utility->value("newsTitleFontSize", 24).toInt();
    //新闻标题字体大小
    m_style["titleImageWidth"] = 80;
    //新闻标题图的宽度（标题左边的图）
    m_style["titleImagesListHeight"] = 80;
    //新闻标题标题下面的横排图片的ListView的高度
#else
    m_style["metroTitleFontPixelSize"] = 28;
    //Metro界面上方大标题的最大字体大小
    m_style["newsInfosFontPixelSize"] = 12;
    //新闻列表中新闻来源和发表时间等新闻信息的字体大小
    m_style["flipchartsTitleFontPixelSize"] = 12;
    //大海报上新闻标题的字体大小
    m_style["titleImageWidth"] = 60;
    //新闻标题图的宽度（标题左边的图）
    m_style["titleImagesListHeight"] = 60;
    //新闻标题标题下面的横排图片的ListView的高度
    m_newsContentFontSize = utility->value("newsContentFontSize", 22).toInt();
    //新闻内容字体大小
    m_newsTitleFontSize = utility->value("newsTitleFontSize", 20).toInt();
    //新闻标题字体大小
#endif

    m_invertedTheme = utility->value("invertedTheme", true).toBool();
    m_noPicturesMode = utility->value("noPicturesMode", false).toBool();
    m_wifiMode  = utility->value("wifiMode", true).toBool();
    m_signature  = utility->value("signature", "").toString();
    m_fullscreenMode  = utility->value("fullscreenMode", false).toBool();
    m_checkUpdate  = utility->value("checkUpdate", true).toBool();
    m_imagesSavePath  = utility->value("imagesSavePath", "").toString();
    m_backgroundImage  = utility->value("backgroundImage", "").toString();
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

bool NCommand::noPicturesMode() const
{
    return m_noPicturesMode;
}

bool NCommand::wifiMode() const
{
    return m_wifiMode;
}

QString NCommand::signature() const
{
    return m_signature;
}

bool NCommand::fullscreenMode() const
{
    return m_fullscreenMode;
}

bool NCommand::checkUpdate() const
{
    return m_checkUpdate;
}

QString NCommand::imagesSavePath() const
{
    return m_imagesSavePath;
}

QString NCommand::backgroundImage() const
{
    return m_backgroundImage;
}

void NCommand::setInvertedTheme(bool arg)
{
    if (m_invertedTheme != arg) {
        m_invertedTheme = arg;
        utility->setValue("invertedTheme", arg);
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

void NCommand::setNoPicturesMode(bool arg)
{
    if (m_noPicturesMode != arg) {
        m_noPicturesMode = arg;
        utility->setValue("noPicturesMode", arg);
        emit noPicturesModeChanged(arg);
    }
}

void NCommand::setWifiMode(bool arg)
{
    if (m_wifiMode != arg) {
        m_wifiMode = arg;
        utility->setValue("wifiMode", arg);
        emit wifiModeChanged(arg);
    }
}

void NCommand::setSignature(QString arg)
{
    if (m_signature != arg) {
        m_signature = arg;
        utility->setValue("signature", arg);
        emit signatureChanged(arg);
    }
}

void NCommand::setFullscreenMode(bool arg)
{
    if (m_fullscreenMode != arg) {
        m_fullscreenMode = arg;
        utility->setValue("fullscreenMode", arg);
        emit fullscreenModeChanged(arg);
    }
}

void NCommand::setCheckUpdate(bool arg)
{
    if (m_checkUpdate != arg) {
        m_checkUpdate = arg;
        utility->setValue("checkUpdate", arg);
        emit checkUpdateChanged(arg);
    }
}

void NCommand::setImagesSavePath(QString arg)
{
    if (m_imagesSavePath != arg) {
        m_imagesSavePath = arg;
        utility->setValue("imagesSavePath", arg);
        emit imagesSavePathChanged(arg);
    }
}

void NCommand::setBackgroundImage(QString arg)
{
    if (m_backgroundImage != arg) {
        m_backgroundImage = arg;
        utility->setValue("backgroundImage", arg);
        emit backgroundImageChanged(arg);
    }
}
