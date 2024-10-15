#include "utilities.hpp"

#include <QProcess>
#include <QTextStream>

using namespace Qt::StringLiterals;

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

QString Utilities::readTextFile(const QUrl &path, int sizeTruncation)
{
    QFile f(path.toLocalFile());
    bool success = f.open(QIODevice::ReadOnly | QIODevice::ReadOnly);
    qDebug() << "read text file open" << success;

    if (!success)
    {
        return u"(error)"_s;
    }

    QTextStream stream(&f);

    QString str;

    if (sizeTruncation == -1)
    {
        // No limit
        str = stream.readAll();
    }
    else
    {
        str = stream.read(sizeTruncation);

        if (str.size() == sizeTruncation)
        {
            //Needed to truncate
            QString addition = QString::asprintf("\n\n... Truncated as text file is over size %d kb ...", sizeTruncation / 1024);
            str += addition;
        }
    }

    qDebug() << "read text file len:" << str.length() << "truncation" << sizeTruncation;

    return str;
}

QString Utilities::toNativeSeparators(const QString &str)
{
    return QDir::toNativeSeparators(str);
}

void Utilities::runOnMainThread(std::function<void()> callback)
{
    QTimer* timer = new QTimer();
    timer->moveToThread(qApp->thread());
    timer->setSingleShot(true);

    QObject::connect(timer, &QTimer::timeout, [=]()
    {
        callback();
        timer->deleteLater();
    });

    QMetaObject::invokeMethod(timer, "start", Qt::QueuedConnection, Q_ARG(int, 0));
}

