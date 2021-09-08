#ifndef DRIVESMODEL_HPP
#define DRIVESMODEL_HPP

#include <QAbstractListModel>
#include <QObject>
#include <QStorageInfo>

class DrivesModel : public QAbstractListModel
{
    Q_OBJECT

    enum Roles
    {
        nameRole = Qt::UserRole + 1,
        pathRole
    };

    QList<QStorageInfo> mDrives;

public:
    DrivesModel(QObject *parent = nullptr);

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // DRIVESMODEL_HPP
