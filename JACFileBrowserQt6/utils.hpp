#ifndef UTILS_HPP
#define UTILS_HPP

#include <QObject>

class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = nullptr);

    Q_INVOKABLE void shellExecute(QString path);

};

#endif // UTILS_HPP
