#ifndef LISTMODEL_HPP
#define LISTMODEL_HPP

#include <QAbstractListModel>

class ListModel : public QAbstractListModel
{
    Q_OBJECT

    static inline const QHash<int, QByteArray> roles = {
        { Qt::UserRole + 0, "field1" },
        { Qt::UserRole + 1, "field2" },
        { Qt::UserRole + 2, "field3" },
        { Qt::UserRole + 3, "field4" },
        { Qt::UserRole + 4, "field5" },
        { Qt::UserRole + 5, "field6" },
        { Qt::UserRole + 6, "field7" },
        { Qt::UserRole + 7, "field8" },
        { Qt::UserRole + 8, "field9" },
    };

public:
    explicit ListModel(QObject *parent = nullptr);

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};


#endif // LISTMODEL_HPP
