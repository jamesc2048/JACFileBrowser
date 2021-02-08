#ifndef UTILS_HPP
#define UTILS_HPP

#include <QObject>
#include <QJSValue>

class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = nullptr);

    Q_INVOKABLE void httpGet(QString url, QJSValue callback);
};

#endif // UTILS_HPP
