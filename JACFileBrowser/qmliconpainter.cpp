#include <QFileIconProvider>

#include "qmliconpainter.hpp"

QMLIconPainter::QMLIconPainter()
{
}

void QMLIconPainter::paint(QPainter *painter)
{
    static QFileIconProvider iconProvider;

    QIcon icon = iconProvider.icon(QFileInfo(m_path));

    if (!icon.isNull())
    {
        icon.paint(painter, 0, 0, width(), height());
    }

    // testing
    //#include <QRandomGenerator>
    //QRandomGenerator rng;
    //painter->fillRect(0, 0, width(), height(), QColor(rng.bounded(0, 255), rng.bounded(0, 255), rng.bounded(0, 255)));
}
