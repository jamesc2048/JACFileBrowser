#include "drivesmodel.hpp"

#include <QtConcurrent>
#include <QElapsedTimer>

#include <utilities.hpp>

using namespace Qt::StringLiterals;

DrivesModel::DrivesModel(QObject *parent)
    : QAbstractListModel{parent}
{
    // It seems like since Qt 6.6, one cannot call the begin/endResetModel functions
    // from another thread anymore.
    // This worked in 6.5... So we use the dispatcher function instead
    QThreadPool::globalInstance()->start([&]
    {
        QElapsedTimer t;
        t.start();
        qDebug() << "Fetching mountedVolumes";

        Utilities::runOnMainThread([this] {
            beginResetModel();
        });

        m_drives = QStorageInfo::mountedVolumes();

        Utilities::runOnMainThread([this] {
            emit rowsChanged();
            endResetModel();
        });

        qDebug("Fetched mountedVolumes, len=%llu, time=%.03fs", m_drives.size(), t.elapsed() / 1000.);
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
