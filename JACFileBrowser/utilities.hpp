#ifndef UTILITIES_HPP
#define UTILITIES_HPP

#include <QtQml>
#include <QObject>

using namespace Qt::StringLiterals;

class Utilities : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit Utilities(QObject *parent = nullptr);

    Q_INVOKABLE bool openInNativeBrowser(const QString& dirPath);
    Q_INVOKABLE QString readTextFile(const QUrl& path, int sizeTruncation = -1);

    static void runOnMainThread(std::function<void()> callback);
};

#endif // UTILITIES_HPP
