#include "contentsmodel.hpp"

ContentsModel::ContentsModel(QString path, QObject *parent) :
    QAbstractListModel(parent), mPath(path)
{
    beginResetModel();

    fileInfoList = QDir(path).entryInfoList(QDir::NoFilter, QDir::DirsFirst);
    isSelectedList = QVector<bool>(fileInfoList.size());

    endResetModel();
}

int ContentsModel::rowCount(const QModelIndex &parent) const
{
    return fileInfoList.size();
}

QVariant ContentsModel::data(const QModelIndex &index, int role) const
{
    if (role == nameRole)
    {
        return fileInfoList.at(index.row()).fileName();
    }

    return "???";
}

QHash<int, QByteArray> ContentsModel::roleNames() const
{
    return
    {
        { nameRole, "name" }
    };
}
