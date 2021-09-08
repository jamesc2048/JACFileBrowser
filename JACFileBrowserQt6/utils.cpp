#include "utils.hpp"

#include <QUrl>
#include <QDesktopServices>
#include <QStandardPaths>
#include <QGuiApplication>

Utils::Utils(QObject *parent) : QObject(parent)
{
}

void Utils::shellExecute(QString path)
{
    // should call ShellExecute, xdg open etc
    // Maybe this is OK?
    QFuture<bool> fut = QtConcurrent::run([=] {
       return QDesktopServices::openUrl(QUrl::fromLocalFile(path));
    });
}

QString Utils::getHomePath()
{
    return QStandardPaths::standardLocations(QStandardPaths::StandardLocation::HomeLocation).at(0);
}

QString Utils::getApplicationVersion()
{
    return qApp->applicationVersion();
}
