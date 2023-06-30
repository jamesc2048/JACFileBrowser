#include "drivesmodel.hpp"

#include <QtConcurrent>

using namespace Qt::StringLiterals;

DrivesModel::DrivesModel(QObject *parent)
    : QAbstractListModel{parent}
{
    QFuture<void> fut = QtConcurrent::run([&]
    {
        qDebug() << "Fetching mountedVolumes";
        beginResetModel();
        m_drives = QStorageInfo::mountedVolumes();
        emit rowsChanged();
        endResetModel();
        qDebug() << "Fetched mountedVolumes";
    });
}

int DrivesModel::rowCount(const QModelIndex &parent = {}) const
{
    Q_UNUSED(parent)
    return (int)m_drives.size();
}

QVariant DrivesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
    {
        return {};
    }

    const QStorageInfo& si = m_drives.at(index.row());

    switch (role)
    {
    case Qt::DisplayRole:
        return QString("%1 (%2)").arg(si.displayName()).arg(si.rootPath());

    case DrivesModel::RootPathRole:
        return si.rootPath();
    }

    return {};
}

QHash<int, QByteArray> DrivesModel::roleNames() const
{
    return {
        { Qt::DisplayRole, "display"_ba },
        { DrivesModel::RootPathRole, "rootPath"_ba }
    };
}

int DrivesModel::rows() const
{
    return rowCount();
}
