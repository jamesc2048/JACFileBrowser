#include "drivesmodel.hpp"

DrivesModel::DrivesModel(QObject *parent) : QAbstractListModel(parent)
{
    // TODO on Unix this should also list common dirs like $HOME etc
    // TODO register for changes in drives (plug/unplug pendrive, etc).
    drives = QDir::drives();
}


int DrivesModel::rowCount(const QModelIndex &parent) const
{
    return drives.size();
}

QVariant DrivesModel::data(const QModelIndex &index, int role) const
{
    return QDir::toNativeSeparators(drives.at(index.row()).absolutePath());
}
