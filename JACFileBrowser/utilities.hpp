#ifndef UTILITIES_HPP
#define UTILITIES_HPP

#include <QtQml>
#include <QObject>

class Utilities : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit Utilities(QObject *parent = nullptr);

    Q_INVOKABLE bool openInNativeBrowser(const QString& dirPath);


};

#endif // UTILITIES_HPP
