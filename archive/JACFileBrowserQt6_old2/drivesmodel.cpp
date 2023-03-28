#include "drivesmodel.hpp"

#ifdef _WIN32
    #include "windows.h"
#endif

#include <QStandardPaths>

DrivesModel::DrivesModel(QObject *parent) : QAbstractListModel(parent)
{
    // TODO register for changes in drives (plug/unplug pendrive, etc).

    auto append = [&](QStandardPaths::StandardLocation loc)
    {
        drives.append({
            QFileInfo(QStandardPaths::standardLocations(loc).at(0)),
            QStandardPaths::displayName(loc),
            true
        });
    };

    append(QStandardPaths::HomeLocation);
    append(QStandardPaths::DesktopLocation);
    append(QStandardPaths::DownloadLocation);
    append(QStandardPaths::DocumentsLocation);
    append(QStandardPaths::MusicLocation);
    append(QStandardPaths::PicturesLocation);
    append(QStandardPaths::MoviesLocation);

    for (const auto& fi : QDir::drives())
    {
        QString name;

#ifdef _WIN32
        char buf[256];
        BOOL ret = GetVolumeInformationA(qPrintable(fi.absolutePath()), buf, sizeof buf, nullptr, nullptr, nullptr, nullptr, 0);

        if (SUCCEEDED(ret))
        {
            name = buf;

            if (name.isEmpty())
            {
                name = "Local Disk";
            }
        }

#else
        // Unix
        name = "Root";
#endif

        drives.append({
            fi,
            name,
            false
        });
    }
}


int DrivesModel::rowCount(const QModelIndex &parent) const
{
    return drives.size();
}

QVariant DrivesModel::data(const QModelIndex &index, int role) const
{
    const auto& drive = drives.at(index.row());

    switch (role)
    {
        case Qt::UserRole + 1:
            return drive.name;

        case Qt::UserRole + 2:
            return drive.fileInfo.absoluteFilePath();

        case Qt::UserRole + 3:
            return drive.isSpecialFolder;
    }

    return {};
}


QHash<int, QByteArray> DrivesModel::roleNames() const
{
    return {
        { Qt::UserRole + 1, "name" },
        { Qt::UserRole + 2, "fullPath" },
        { Qt::UserRole + 3, "isSpecialFolder" },
    };
}
