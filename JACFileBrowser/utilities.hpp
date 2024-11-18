#ifndef UTILITIES_HPP
#define UTILITIES_HPP

#include <QtQml>
#include <QObject>

#include <stacktrace>
#include <exception>
#include <string>
#include <iostream>

using namespace Qt::StringLiterals;

class Utilities : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit Utilities(QObject *parent = nullptr);

    Q_INVOKABLE bool openInNativeBrowser(const QString& dirPath);
    Q_INVOKABLE QString readTextFile(const QUrl& path, int sizeTruncation = -1);
    Q_INVOKABLE QString toNativeSeparators(const QString& str);

    static void runOnMainThread(std::function<void()> callback);
};

class Exception : public std::exception
{
//    std::stacktrace stacktrace;

public:
    Exception();
    std::string str();
};

#endif // UTILITIES_HPP
