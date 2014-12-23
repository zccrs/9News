#include <QDateTime>
#include <QDebug>
#include <QDir>
#include <QDesktopWidget>
#include <QApplication>
#include <QSystemDeviceInfo>
#include "ncommand.h"
#include "utility.h"

NCommand::NCommand(QObject *parent) :
    QObject(parent)
{
    utility = Utility::createUtilityClass();

    themeList<<ThemeInfo(":/qml/theme/default.ini", tr("default"))<<
               ThemeInfo(":/qml/theme/default-inverse.ini", tr("default-inverse"));

    currentThemeIndex = -1;
    //初始化当前主题index为-1
    getCustomThemeList();
    //获取所有本地自定义主题
    setTheme(utility->value("theme", "default").toString());
    //设置主题
    qDebug()<<QString::fromUtf8("主题初始化完毕");
#ifdef HARMATTAN_BOOSTER
    m_newsContentFontSize = utility->value("newsContentFontSize", 26).toInt();
    //新闻内容字体大小
    m_newsTitleFontSize = utility->value("newsTitleFontSize", 24).toInt();
    //新闻标题字体大小
#else
    m_newsContentFontSize = utility->value("newsContentFontSize", 22).toInt();
    //新闻内容字体大小
    m_newsTitleFontSize = utility->value("newsTitleFontSize", 20).toInt();
    //新闻标题字体大小
#endif

    m_noPicturesMode = utility->value("noPicturesMode", false).toBool();
    m_wifiMode  = utility->value("wifiMode", true).toBool();
    m_signature  = utility->value("signature", "").toString();
    m_fullscreenMode  = utility->value("fullscreenMode", false).toBool();
    m_checkUpdate  = utility->value("checkUpdate", true).toBool();
    m_imagesSavePath  = utility->value("imagesSavePath", "").toString();

    connect(&networkInfo,
            SIGNAL(networkStatusChanged(QSystemNetworkInfo::NetworkMode,QSystemNetworkInfo::NetworkStatus)),
            SLOT(onNetworkStatusChanged(QSystemNetworkInfo::NetworkMode,QSystemNetworkInfo::NetworkStatus)));

    connect(&networkInfo, SIGNAL(networkSignalStrengthChanged(QSystemNetworkInfo::NetworkMode,int)),
            SLOT(onNetworkSignalStrengthChanged(QSystemNetworkInfo::NetworkMode,int)));

    connect(&networkInfo, SIGNAL(networkModeChanged(QSystemNetworkInfo::NetworkMode)),
            SLOT(onNetworkModeChanged(QSystemNetworkInfo::NetworkMode)));
}

NCommand::SystemType NCommand::systemTye() const
{
#ifdef HARMATTAN_BOOSTER
    return Harmattan;
#else
    return Symbian;
#endif
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

QString NCommand::theme() const
{
    return m_theme;
}

QString NCommand::phoneModel() const
{
    QSystemDeviceInfo info;
    return info.model();
}

bool NCommand::showNewsImage()
{
    if(m_noPicturesMode){//如果是无图模式
        return false;
    }else if(m_wifiMode){
        //如果是仅wifi显示图片模式
        return networkInfo.currentMode()==QSystemNetworkInfo::WlanMode;
    }

    return true;
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

QUrl NCommand::getIconSource(QVariant invertedTheme, const QString &iconName,
                             const QString &format, bool utility) const
{
#ifdef HARMATTAN_BOOSTER
    QString source = "qrc:/images/"+iconName+
            (utility?"":"_meego")+
            (invertedTheme.toBool()?".":"_inverse.")+format;
#else
    QString source = "qrc:/images/"+iconName+
            (utility?"":"_symbian")+
            (invertedTheme.toBool()?".":"_inverse.")+format;
#endif
    return source;
}

void NCommand::setNoPicturesMode(bool arg)
{
    if (m_noPicturesMode != arg) {
        m_noPicturesMode = arg;
        utility->setValue("noPicturesMode", arg);
        emit noPicturesModeChanged(arg);
        emit showNewsImageChanged();
    }
}

void NCommand::setWifiMode(bool arg)
{
    if (m_wifiMode != arg) {
        m_wifiMode = arg;
        utility->setValue("wifiMode", arg);
        emit wifiModeChanged(arg);
        emit showNewsImageChanged();
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

void NCommand::themeSwitch()
{
    int index = (currentThemeIndex+1)%themeList.length();
    setTheme(index);
}

bool NCommand::setTheme(const QString& arg)
{
    if (m_theme != arg) {
        int i;
        for(i=0;i<themeList.length();++i){
            if(themeList[i].themeName == arg)
                break;
        }
        return setTheme(i);
    }

    return true;
}

bool NCommand::setTheme(int index)
{
    if(index<0||index>=themeList.length()||index==currentThemeIndex)
        return false;

    ThemeInfo info = themeList[index];
    QSettings settings(info.filePath, QSettings::IniFormat);
    currentThemeIndex = index;
    updateStyle(settings);
    m_theme = info.themeName;
    utility->setValue("theme", m_theme);
    qDebug()<<QString::fromUtf8("主题切换为：")<<m_theme;
    emit themeChanged(m_theme);

    return true;
}

QVariantList NCommand::getThemeList() const
{
    QVariantList list;
    foreach(ThemeInfo info, themeList){
        list<<info.themeName;
    }

    return list;
}

QString NCommand::readFile(const QUrl fileName) const
{
    QFile file(fileName.toLocalFile());
    if(file.open(QIODevice::ReadOnly)){
        QString temp_str = QString::fromUtf8(file.readAll());
        file.close();
        return temp_str;
    }

    return "";
}

void NCommand::onNetworkStatusChanged(QSystemNetworkInfo::NetworkMode mode,
                                      QSystemNetworkInfo::NetworkStatus status)
{
    //qDebug()<<mode<<status;
}

void NCommand::onNetworkSignalStrengthChanged(QSystemNetworkInfo::NetworkMode mode, int strength)
{
    //qDebug()<<mode<<strength;
}

void NCommand::onNetworkModeChanged(QSystemNetworkInfo::NetworkMode mode)
{
    emit showNewsImageChanged();
}

void NCommand::getCustomThemeList()
{
#ifdef HARMATTAN_BOOSTER
    QDir dir("/opt/9News/theme_meego");
#else
    QString theme_path;
    if(qApp->desktop()->screen(0)->width()==640)
        theme_path = "./theme_e6";
    else
        theme_path = "./theme_symbian";

    QDir dir(theme_path);
#endif
    dir.setFilter(QDir::Files);
    QStringList namesFilter;
    namesFilter<<"*.ini";
    dir.setNameFilters(namesFilter);

    foreach(QFileInfo info, dir.entryInfoList()){
        ThemeInfo theme_info;
        theme_info.filePath = info.absoluteFilePath();
        QString default_themeName = info.fileName().replace(".ini", "");
        QSettings settings(theme_info.filePath, QSettings::IniFormat);
        theme_info.themeName = settings.value("themeName", default_themeName).toString();
        themeList<<theme_info;
    }
}

void NCommand::setStyleProperty(const QString &name, const QSettings &settings, const QVariant defaultValue)
{
    m_style[name] = settings.value(name, defaultValue);
}

void NCommand::updateStyle(const QSettings& settings)
{
#ifdef HARMATTAN_BOOSTER
    setStyleProperty("metroTitleFontPixelSize", settings, 32);
    //Metro界面上方大标题的最大字体大小
    setStyleProperty("newsInfosFontPixelSize", settings, 16);
    //新闻列表中新闻来源和发表时间等新闻信息的字体大小
    setStyleProperty("flipchartsTitleFontPixelSize", settings, 16);
    //大海报上新闻标题的字体大小
    setStyleProperty("titleImageWidth", settings, 80);
    //新闻标题图的宽度（标题左边的图）
    setStyleProperty("titleImagesListHeight", settings, 80);
    //新闻标题标题下面的横排图片的ListView的高度
    setStyleProperty("toUpIconWidth", settings, 80);
    //新闻列表中一键返回顶部的图标按钮的宽度
#else
    setStyleProperty("metroTitleFontPixelSize", settings, 28);
    //Metro界面上方大标题的最大字体大小
    setStyleProperty("newsInfosFontPixelSize", settings, 12);
    //新闻列表中新闻来源和发表时间等新闻信息的字体大小
    setStyleProperty("flipchartsTitleFontPixelSize", settings, 12);
    //大海报上新闻标题的字体大小
    setStyleProperty("titleImageWidth", settings, 60);
    //新闻标题图的宽度（标题左边的图）
    setStyleProperty("titleImagesListHeight", settings, 60);
    //新闻标题标题下面的横排图片的ListView的高度
    setStyleProperty("toUpIconWidth", settings, 50);
    //新闻列表中一键返回顶部的图标按钮的宽度
#endif
    setStyleProperty("invertedTheme", settings, true);
    //是否是暗色主题
    setStyleProperty("backgroundImage", settings, "");
    //背景图片的地址，如果是本地文件要加上file:///前缀，并且最好使用绝对路径
    setStyleProperty("backgroundImageOpacity", settings, 1);
    //设置背景图片的不透明度（值越小透明度越高）
    setStyleProperty("newsTitleFontColor", settings, QColor("#000"));
    //标题文字颜色
    setStyleProperty("newsContentFontColor", settings, QColor("#000"));
    //新闻内容字体颜色
    setStyleProperty("newsInfoFontColor", settings, QColor("#888"));
    //新闻信息字体的颜色（新闻标题下面那行小字）
    setStyleProperty("oldNewsTitleFontColor", settings, QColor("#666"));
    //已经阅读过的新闻的标题颜色
    setStyleProperty("metroActiveTitleFontColor", settings, QColor("#000"));
    //metro活跃页大标题的字体颜色
    setStyleProperty("metroInactiveTitleFontColor", settings, QColor("#888"));
    //metro非活跃页大标题的字体颜色
    setStyleProperty("inactiveFontColor", settings, QColor("#888"));
    //此颜色值用于那些在Page中不是主教，但必须要显示的文本的颜色，例如设置界面用来分割每一栏设置项的标示文本
    setStyleProperty("toolBarOpacity", settings, 1);
    //控制工具栏背景图的不透明度
    setStyleProperty("cuttingLineVisible", settings, true);
    //控制分割线是否显示,只对新闻列表有用
    setStyleProperty("webViewBackgroundImage", settings, true);
    setStyleProperty("toolBarInverted", settings, true);
    //控制工具栏图标的invertedTheme
#ifdef HARMATTAN_BOOSTER
    QString temp_str = m_style["toolBarInverted"].toBool()?"-inverted":"";
    QUrl defaule_backImage = "image://theme/meegotouch-toolbar-portrait"+temp_str+"-background";
#else
    QUrl defaule_backImage = getIconSource(m_style["toolBarInverted"], "toolbar", "svg");
#endif
    setStyleProperty("toolBarBackgroundImage", settings, defaule_backImage);
    //工具栏背景图路径
    setStyleProperty("menuInverted", settings, true);
    //控制菜单的invertedTheme
    setStyleProperty("switchInverted", settings, true);
    //控制Switch控件的invertedTheme
    setStyleProperty("sliderInverted", settings, true);
    //控制Slider控件的invertedTheme
    setStyleProperty("buttonInverted", settings, true);
    //控制Button或ToolButton控件的invertedTheme
    //但是只用于单独的button控件，例如工具栏或者菜单栏上的button则按工具栏或者菜单栏的Inverted设置
    setStyleProperty("textInputInverted", settings, true);
    //控制TextArea或者TextField等的invertedTheme
    setStyleProperty("dialogInverted", settings, true);
    //控制对话框的invertedTheme
    setStyleProperty("scrollBarInverted", settings, true);
    //控制ScroolBar控件的Inverted
    setStyleProperty("defaultImage", settings, "qrc:/images/defaultImage.svg");
    //在无图模式下默认显示的图片
    setStyleProperty("loadingImage", settings, "qrc:/images/loading.png");
    //在图片加载完成之前显示的加载指示器
    setStyleProperty("showBackgroundImageMask", settings, false);
    //记录背景图上的遮罩是否开启
    setStyleProperty("backgroundImageMaskColor", settings, QColor("black"));
    //图片遮罩的背景颜色
    setStyleProperty("backgroundImageMaskOpacity", settings, 0.5);
    //背景图遮罩的不透明度

    emit styleChanged(m_style);
}
