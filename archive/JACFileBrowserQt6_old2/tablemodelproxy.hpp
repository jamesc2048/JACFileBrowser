#ifndef TABLEMODELPROXY_HPP
#define TABLEMODELPROXY_HPP

#include <QAbstractTableModel>

class TableModelProxy : public QAbstractTableModel
{
    Q_OBJECT

    QAbstractItemModel *proxy;

public:
    explicit TableModelProxy(QAbstractListModel *proxy);

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    int columnCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
};



#endif // TABLEMODELPROXY_HPP
