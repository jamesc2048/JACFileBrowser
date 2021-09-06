#include "contentsmodel.hpp"

ContentsModel::ContentsModel(QObject *parent) : QAbstractListModel(parent)
{
    // TODO temp
    loadDirectory("C:\\Users\\James Crisafulli\\Downloads");
}


int ContentsModel::rowCount(const QModelIndex &parent) const
{
    return contents.size();
}

QVariant ContentsModel::data(const QModelIndex &index, int role) const
{
    const QFileInfo &elem = contents.at(index.row());

    switch (role)
    {
        // Name
        case Qt::UserRole + 0:
            return elem.fileName();
        // Size
        case Qt::UserRole + 1:
        {
            if (elem.isDir())
            {
                // Mimic Windows explorer on this
                return QStringLiteral("");
            }

            // TODO dynamic human readable size
            double humanSize = elem.size();
            humanSize /= (1024.0 * 1024.0);

            return QString("%1 MB").arg(humanSize, 0, 'f', 2);
        }
        // IsDir
        case Qt::UserRole + 2:
            return elem.isDir();

        // Absolute Path
        case Qt::UserRole + 3:
        {
            return elem.filePath();
        }

        default:
            return "Unknown role";
    }
}


QHash<int, QByteArray> ContentsModel::roleNames() const
{
    return roles;
}

void ContentsModel::loadDirectory(QString path)
{
    beginResetModel();

    contents = QDir(QDir::cleanPath(path))
                .entryInfoList(QDir::Filter::NoFilter, QDir::SortFlag::DirsFirst | QDir::SortFlag::Name);

    endResetModel();
}
