#include "listmodel.hpp"

ListModel::ListModel(QObject *parent) : QAbstractListModel(parent)
{

}

int ListModel::rowCount(const QModelIndex &parent) const
{
    return 100;
}

QVariant ListModel::data(const QModelIndex &index, int role) const
{
    return QString("row %1, role %2").arg(index.row()).arg(roles[role]);
}

QHash<int, QByteArray> ListModel::roleNames() const
{
    return roles;
}
