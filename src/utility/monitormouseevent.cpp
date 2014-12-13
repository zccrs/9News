<<<<<<< HEAD
#include "monitormouseevent.h"
#include <QGraphicsSceneMouseEvent>
#include <QDebug>
#include <QApplication>

#if(QT_VERSION>=0x050000)
MonitorMouseEvent::MonitorMouseEvent(QQuickPaintedItem *parent) :
    QQuickPaintedItem(parent)
#else
MonitorMouseEvent::MonitorMouseEvent(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
#endif
{
    m_target = NULL;
}

QDeclarativeItem *MonitorMouseEvent::target() const
{
    return m_target;
}

void MonitorMouseEvent::setTarget(QDeclarativeItem *arg)
{
    if(arg!=m_target){
        if(arg){
            setAcceptedMouseButtons(Qt::LeftButton);
            arg->installEventFilter(this);
        }else if(m_target){
            m_target->removeEventFilter(this);
            setAcceptedMouseButtons(Qt::NoButton);
        }
        m_target = arg;
        setParent(arg);
        emit targetChanged(arg);
    }
}

#if(QT_VERSION>=0x050000)
#else
void MonitorMouseEvent::mousePressEvent(QGraphicsSceneMouseEvent *event)
{
    emit mousePress(event->pos());
    QDeclarativeItem::mousePressEvent(event);
}

bool MonitorMouseEvent::eventFilter(QObject *target, QEvent *event)
{
    if(target==m_target){
        QGraphicsSceneMouseEvent* mouse_event = static_cast<QGraphicsSceneMouseEvent*>(event);

        if(event->type()==QEvent::GraphicsSceneMouseRelease||event->type()==QEvent::MouseButtonRelease){
            emit mouseRelease(mouse_event->pos());
        }else if(event->type()==QEvent::GraphicsSceneMouseDoubleClick||event->type()==QEvent::MouseButtonDblClick){
            emit mouseDoubleClicked(mouse_event->pos());
        }
    }

    return false;
}
#endif
=======
#include "monitormouseevent.h"
#include <QGraphicsSceneMouseEvent>
#include <QDebug>
#include <QApplication>

#if(QT_VERSION>=0x050000)
MonitorMouseEvent::MonitorMouseEvent(QQuickPaintedItem *parent) :
    QQuickPaintedItem(parent)
#else
MonitorMouseEvent::MonitorMouseEvent(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
#endif
{
    m_target = NULL;
    setAcceptedMouseButtons(Qt::LeftButton);
}

QObject *MonitorMouseEvent::target() const
{
    return m_target;
}

void MonitorMouseEvent::setTarget(QObject *arg)
{
    if(arg!=m_target){
        m_target = arg;
        if(arg)
            arg->installEventFilter(this);
        setParent(arg);
        emit targetChanged(arg);
    }
}

#if(QT_VERSION>=0x050000)
#else
void MonitorMouseEvent::mousePressEvent(QGraphicsSceneMouseEvent *event)
{
    emit mousePress(event->pos());
    QDeclarativeItem::mousePressEvent(event);
}

bool MonitorMouseEvent::eventFilter(QObject *target, QEvent *event)
{
    if(target==m_target){
        QGraphicsSceneMouseEvent* mouse_event = static_cast<QGraphicsSceneMouseEvent*>(event);

        if(event->type()==QEvent::GraphicsSceneMouseRelease||event->type()==QEvent::MouseButtonRelease){
            emit mouseRelease(mouse_event->pos());
        }else if(event->type()==QEvent::GraphicsSceneMouseDoubleClick||event->type()==QEvent::MouseButtonDblClick){
            emit mouseDoubleClicked(mouse_event->pos());
        }
    }

    return false;
}
#endif
>>>>>>> 5eadeb2e4c633312e53c5ed6b7be596665fabe33
