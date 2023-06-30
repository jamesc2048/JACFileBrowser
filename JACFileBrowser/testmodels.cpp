
#include <testmodels.hpp>

TestListModel::TestListModel(QObject *parent) : QAbstractListModel(parent)
{
}

int TestListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_rows;
}

QVariant TestListModel::data(const QModelIndex &index, int role) const
{
    switch (role)
    {
    case Qt::DisplayRole:
        return QString("data: %1").arg(index.row());
    default:
        return {};
    }
}

TestTableModel::TestTableModel(QObject *parent) : QAbstractTableModel(parent)
{
}

int TestTableModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_rows;
}

int TestTableModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_columns;
}

QVariant TestTableModel::data(const QModelIndex &index, int role) const
{
    switch (role)
    {
    case Qt::DisplayRole:
        return QString("data %1,%2").arg(index.row()).arg(index.column());
    default:
        return {};
    }
}

QVariant TestTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    Q_UNUSED(orientation)
    switch (role)
    {
    case Qt::DisplayRole:
        return QString("header %1").arg(section);
    default:
        return {};
    }
}
