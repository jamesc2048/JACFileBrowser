#include "contentsmodel.hpp"

ContentsModel::ContentsModel(QString path, QObject *parent) :
    QAbstractListModel(parent), mPath(path)
{
    connect(this, &ContentsModel::pathChanged, &ContentsModel::loadFiles);

    loadFiles();
}

int ContentsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return fileInfoList.size();
}

QVariant ContentsModel::data(const QModelIndex &index, int role) const
{
    const int row = index.row();

    switch (role)
    {
        case nameRole:
            return fileInfoList.at(row).fileName();

        case isSelectedRole:
            return isSelectedList.at(row);

        case isFolderRole:
            return fileInfoList.at(row).isDir();

        case sizeRole:
            return fileInfoList.at(row).size();

        case absolutePathRole:
            return fileInfoList.at(row).absoluteFilePath();

        default:
            return "Unknown role";
    }
}

bool ContentsModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    switch (role)
    {
        case isSelectedRole:
            isSelectedList[index.row()] = value.toBool();
            break;

        default:
            return false;
    }

    emit dataChanged(index, index, { role });
    return true;
}

QHash<int, QByteArray> ContentsModel::roleNames() const
{
    return
    {
        { nameRole, "name" },
        { isSelectedRole, "isSelected" },
        { isFolderRole, "isFolder" },
        { sizeRole, "size" },
        { absolutePathRole, "absolutePath" },
    };
}

void ContentsModel::loadFiles()
{
    qDebug() << "Reloading files at " << mPath;

    beginResetModel();

    fileInfoList = QDir(mPath).entryInfoList(QDir::NoFilter, QDir::DirsFirst);
    isSelectedList = QVector<bool>(fileInfoList.size());

    endResetModel();
}
