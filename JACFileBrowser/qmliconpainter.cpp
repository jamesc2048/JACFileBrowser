#include <QFileIconProvider>

#include "qmliconpainter.hpp"

QMLIconPainter::QMLIconPainter()
{
}

void QMLIconPainter::paint(QPainter *painter)
{
    static QFileIconProvider iconProvider;

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
