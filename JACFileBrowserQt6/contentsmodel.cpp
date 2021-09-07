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
    // TODO loading state on separate thread, with loading variables
    beginResetModel();

    QString cleanPath = QDir::toNativeSeparators(QDir::cleanPath(path));
    setCurrentDir(cleanPath);

    contents = QDir(cleanPath)
                .entryInfoList(QDir::Filter::NoFilter,
                               QDir::SortFlag::DirsFirst | QDir::SortFlag::Name);

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
