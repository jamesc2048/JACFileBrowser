#include "utils.hpp"

#include <QUrl>
#include <QDesktopServices>

Utils::Utils(QObject *parent) : QObject(parent)
{
}

void Utils::shellExecute(QString path)
{
    // should call ShellExecute, xdg open etc
    // Maybe this is OK?
    QDesktopServices::openUrl(QUrl::fromLocalFile(path));
}
