#include "tablemodelproxy.hpp"

TableModelProxy::TableModelProxy(QAbstractListModel *proxy) :
    QAbstractTableModel(proxy),
    proxy(proxy)
{

}


int TableModelProxy::rowCount(const QModelIndex &parent) const
{
    return proxy->rowCount(parent);
}

int TableModelProxy::columnCount(const QModelIndex &parent) const
{
    // map rolenames to columns
    return proxy->roleNames().size();
}

QVariant TableModelProxy::data(const QModelIndex &index, int role) const
{
    // map rolenames to columns
    // map from 0 instead of from 1
    return proxy->data(proxy->index(index.row(), 0), Qt::UserRole + index.column());
}


QVariant TableModelProxy::headerData(int section, Qt::Orientation orientation, int role) const
{
    return proxy->roleNames().find(Qt::UserRole + section).value();
}
