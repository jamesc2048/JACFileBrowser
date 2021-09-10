#include "tablemodelproxy.hpp"

TableModelProxy::TableModelProxy(QAbstractListModel *proxy) :
    QAbstractTableModel(proxy),
    proxy(proxy)
{
    // TODO maybe this should subclass QSortProxyFilter model to avoid this?
    connect(proxy, &QAbstractListModel::modelAboutToBeReset, [this] {
        beginResetModel();
    });

    connect(proxy, &QAbstractListModel::modelReset, [this] {
        endResetModel();
    });

    connect(proxy, &QAbstractListModel::dataChanged, [this]
            (const QModelIndex &topLeft,
            const QModelIndex &bottomRight,
            const QList<int> &roles = QList<int>()) {

        qDebug("contentsModel dataChanged %d %d, %d %d", topLeft.row(), topLeft.column(), bottomRight.row(), bottomRight.column());

        emit dataChanged(index(topLeft.row(), 0), index(bottomRight.row(), columnCount({}) - 1));
    });
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
    // Special row-wide IsDir role
    if (role == Qt::UserRole + 2)
    {
        return proxy->data(proxy->index(index.row(), 0), Qt::UserRole + 2);
    }

    // Special row-wide IsSelected role
    if (role == Qt::UserRole + 5)
    {
        return proxy->data(proxy->index(index.row(), 0), Qt::UserRole + 5);
    }

    // map remaining to columns
    // map from 0 instead of from 1
    return proxy->data(proxy->index(index.row(), 0), Qt::UserRole + index.column());
}


QVariant TableModelProxy::headerData(int section, Qt::Orientation orientation, int role) const
{
    return proxy->roleNames().find(Qt::UserRole + section).value();
}


QHash<int, QByteArray> TableModelProxy::roleNames() const
{
    // This way allow to fetch "isDir" and other useful roles from other columns
    auto roles = proxy->roleNames();

    // restore used display role
    roles[Qt::DisplayRole] = "display";

    return roles;
}


bool TableModelProxy::setData(const QModelIndex &index, const QVariant &value, int role)
{
    bool success = proxy->setData(proxy->index(index.row(), 0), value, Qt::UserRole + 5);

    if (success)
    {
        emit dataChanged(index, index, QList<int>() << Qt::DisplayRole);
    }

    return success;
}
