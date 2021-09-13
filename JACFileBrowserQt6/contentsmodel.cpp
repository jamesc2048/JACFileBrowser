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
    if (!index.isValid())
    {
        return {};
    }

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

            // TODO dynamic sizes? MB GB TB?
            uint64_t humanSize = (uint64_t)(elem.size() / 1024.0);

            return QString("%1 KB").arg(locale.toString(humanSize));
        }
        // IsDir
        case Qt::UserRole + 2:
            return elem.isDir();

        // Absolute Path
        case Qt::UserRole + 3:
            return QDir::toNativeSeparators(elem.filePath());

        // Date Modified
        case Qt::UserRole + 4:
            return elem.lastModified().toString("yyyy/MM/dd hh:mm");

        // IsSelected
        case Qt::UserRole + 5:
            return (bool)(contentFlags[index.row()] & (uint8_t)ContentFlags::IsSelected);

        default:
            return "Unknown role";
    }
}


QHash<int, QByteArray> ContentsModel::roleNames() const
{
    return roles;
}

bool ContentsModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid())
    {
        return false;
    }

    switch (role)
    {
        // IsSelected
        case Qt::UserRole + 5:
            if (value.toBool())
            {
                contentFlags[index.row()] |= (uint8_t)ContentFlags::IsSelected;
            }
            else
            {
                contentFlags[index.row()] &= ~(uint8_t)ContentFlags::IsSelected;
            }
            break;

        default:
            return false;
    }

    qDebug("set data %d", contentFlags[index.row()]);

    emit dataChanged(index, index, QList<int>() << role);
    return true;
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
    contentFlags.resize(contents.size());
    memset(contentFlags.data(), 0, contentFlags.size());

    qDebug("%s: entryInfoList returned %d items", qPrintable(currentDir()), contents.size());

    endResetModel();
}

void ContentsModel::clearSelection()
{
    for (auto& flags : contentFlags)
    {
        flags &= ~(uint8_t)ContentFlags::IsSelected;
    }

    emit dataChanged(index(0, 0), index(contentFlags.size() - 1, 0), QList<int>() << Qt::UserRole + 5);
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
