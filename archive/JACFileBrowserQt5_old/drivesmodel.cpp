#include "drivesmodel.hpp"

DrivesModel::DrivesModel(QObject *parent) : QAbstractListModel(parent)
{
    mDrives = QStorageInfo::mountedVolumes();
}

int DrivesModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mDrives.size();
}

QVariant DrivesModel::data(const QModelIndex &index, int role) const
{
    Q_UNUSED(index);
    Q_UNUSED(role);

    const QStorageInfo& si = mDrives.at(index.row());

    qDebug("data role: %d", role);

    switch (role)
    {
        case nameRole:
            return si.name();
        case pathRole:
            return si.rootPath();
    }

    return "unknown role";
}

QHash<int, QByteArray> DrivesModel::roleNames() const
{
    return
    {
        { nameRole, "name" },
        { pathRole, "path" }
    };
}
