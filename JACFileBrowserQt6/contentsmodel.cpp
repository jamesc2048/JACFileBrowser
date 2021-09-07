#include "contentsmodel.hpp"

ContentsModel::ContentsModel(QObject *parent) : QAbstractListModel(parent)
{
}


int ContentsModel::rowCount(const QModelIndex &parent) const
{
    return contents.size();
}

QVariant ContentsModel::data(const QModelIndex &index, int role) const
{
    const QFileInfo &elem = contents.at(index.row());

    switch (role)
    {
        // Name
        case Qt::UserRole + 0:
            return QDir::toNativeSeparators(elem.fileName());
        // Size
        case Qt::UserRole + 1:
        {
            if (elem.isDir())
            {
                // Mimic Windows explorer on this
                return QStringLiteral("");
            }

            // TODO dynamic human readable size
            double humanSize = elem.size();
            humanSize /= (1024.0 * 1024.0);

            return QString("%1 MB").arg(humanSize, 0, 'f', 2);
        }
        // IsDir
        case Qt::UserRole + 2:
            return elem.isDir();

        // Absolute Path
        case Qt::UserRole + 3:
            return QDir::toNativeSeparators(elem.filePath());

        // Date Modified
        case Qt::UserRole + 4:
            return elem.lastModified().toString("yyyy-MM-dd hh:mm:ss");

        default:
            return "Unknown role";
    }
}


QHash<int, QByteArray> ContentsModel::roleNames() const
{
    return roles;
}

void ContentsModel::loadDirectory(QString path)
{
    QString cleanPath = QDir::toNativeSeparators(QDir::cleanPath(path));

    // if it didn't get cleaned up by cleanPath it's an invalid path
    if (cleanPath.endsWith(".."))
    {
        qDebug("Trying to up navigate from %s to %s: disallowed", qPrintable(currentDir()), qPrintable(cleanPath));
        return;
    }

    // TODO loading state on separate thread, with loading variables
    beginResetModel();

    setCurrentDir(cleanPath);

    contents = QDir(cleanPath)
                .entryInfoList(QDir::AllEntries | QDir::Filter::NoDotAndDotDot,
                               QDir::SortFlag::DirsFirst | QDir::SortFlag::Name);

    qDebug("%s: entryInfoList returned %d items", qPrintable(currentDir()), contents.size());

    endResetModel();
}

const QString &ContentsModel::currentDir() const
{
    return m_currentDir;
}

void ContentsModel::setCurrentDir(const QString &newCurrentDir)
{
    if (m_currentDir == newCurrentDir)
        return;

    m_currentDir = newCurrentDir;

    emit currentDirChanged();
}
