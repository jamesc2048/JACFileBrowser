#ifndef UTILS_HPP
#define UTILS_HPP

#include <QObject>

#include <QtConcurrent/QtConcurrent>

class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = nullptr);

    Q_INVOKABLE void shellExecute(QString path);
    Q_INVOKABLE QString getHomePath();
    Q_INVOKABLE QString getApplicationVersion();

};

#endif // UTILS_HPP
