#ifndef QMLICONPAINTER_HPP
#define QMLICONPAINTER_HPP

#include <QQuickPaintedItem>
#include <QObject>
#include <QQmlEngine>
#include <QPainter>
#include <QFileInfo>

class QMLIconPainter : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged FINAL)

public:
    QMLIconPainter();

    void paint(QPainter *painter) override;
    QString path() const;
    void setPath(const QString &newPath);

signals:
    void pathChanged();
private:
    QString m_path;
};

#endif // QMLICONPAINTER_HPP
