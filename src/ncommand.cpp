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
    return System;
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
