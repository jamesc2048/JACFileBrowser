#include <QFileIconProvider>

#include "qmliconpainter.hpp"

QMLIconPainter::QMLIconPainter()
{
}

void QMLIconPainter::paint(QPainter *painter)
{
    static QFileIconProvider iconProvider;

    if (!isVisible() || !isEnabled())
    {
        return;
    }

    // TODO performance: if it's a .lnk file or .exe always fetch the icon. if not use a cache
    // Could there be a way to pass the QFileInfo directly?
    // Maybe pass a weak reference to the QFileInfo in the array?
    // Have an API that returns the QFileInfos?
    QIcon icon = iconProvider.icon(QFileInfo(m_path));

    //qDebug() << "Paint icon for" << m_path << icon;

    if (!icon.isNull())
    {
        icon.paint(painter, 0, 0, width(), height());
    }

    // testing
    //#include <QRandomGenerator>
    //QRandomGenerator rng;
    //painter->fillRect(0, 0, width(), height(), QColor(rng.bounded(0, 255), rng.bounded(0, 255), rng.bounded(0, 255)));
}

QString QMLIconPainter::path() const
{
    return m_path;
}

void QMLIconPainter::setPath(const QString &newPath)
{
    if (m_path == newPath)
        return;

    // if old path is not empty, the component is being reused by TableView, we need to re-render
    bool shouldRerender = !m_path.isEmpty();

    m_path = newPath;
    emit pathChanged();

    if (shouldRerender)
    {
        update();
    }
}
