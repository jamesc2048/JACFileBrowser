#include "utilities.hpp"
#include <QProcess>

Utilities::Utilities(QObject *parent)
    : QObject{parent}
{

}

bool Utilities::openInNativeBrowser(const QString &dirPath)
{
    // TODO would be cool to preserve the selection
    // "explorer /select,FileName"
    QDir dir(dirPath);

    if (dir.exists())
    {
        QString program;

#ifdef Q_OS_WIN
        program = u"explorer"_s;
#endif

#ifdef Q_OS_MACOS
        // TODO untested
        program = u"open"_qs;
#endif

#ifdef Q_OS_LINUX
        // TODO untested
        program = u"xdg-open"_qs;
#endif

        QStringList args = { dirPath };

        if (!program.isEmpty())
        {
            return QProcess::startDetached(program, args);
        }
    }

    return false;
}

