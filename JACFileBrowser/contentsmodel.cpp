#include "contentsmodel.hpp"

#include <QtConcurrent>

ContentsModel::ContentsModel(QObject *parent)
    : QAbstractItemModel(parent)
{
}

int ContentsModel::rowCount(const QModelIndex &parent) const
{
    return (int)fileInfoList.size();
}

int ContentsModel::columnCount(const QModelIndex &parent) const
{
    // Filename, size
    return 2;
}

QVariant ContentsModel::data(const QModelIndex &index, int role) const
{
    const int row = index.row();
    const int col = index.column();

    const QFileInfo &fi = fileInfoList.at(row);

    if (role == Qt::DisplayRole)
    {
        switch (col)
        {
        case 0:
            return fi.fileName();
        case 1:
            return fi.isFile() ? QString("%1 MB").arg(fi.size() / (1024. * 1024.), 0, 'f', 2) : "";
        default:
            return "Unknown";
        }
    }

    return {};
}

QHash<int, QByteArray> ContentsModel::roleNames() const
{
    return QAbstractItemModel::roleNames();
}

QVariant ContentsModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return QString::number(section);
}

QModelIndex ContentsModel::index(int row, int column, const QModelIndex &parent) const
{
    return createIndex(row, column);
}

QModelIndex ContentsModel::parent(const QModelIndex &child) const
{
    return {};
}

ModelMode ContentsModel::modelMode() const
{
    return m_modelMode;
}

void ContentsModel::setModelMode(ModelMode newModelMode)
{
    if (m_modelMode == newModelMode)
        return;
    m_modelMode = newModelMode;
    emit modelModeChanged();
}

QString ContentsModel::currentDir() const
{
    return m_currentDir;
}

void ContentsModel::setCurrentDir(const QString &newCurrentDir)
{
    if (m_currentDir == newCurrentDir)
        return;
    m_currentDir = QDir::toNativeSeparators(newCurrentDir);
    emit currentDirChanged();

    beginResetModel();

    QDir dir(m_currentDir);

    qDebug("Fetch dir %s", qPrintable(dir.absolutePath()));

    fileInfoList = dir.entryInfoList(QDir::Filter::AllEntries | QDir::Filter::NoDotAndDotDot,
                                     QDir::SortFlag::DirsFirst | QDir::SortFlag::Name | QDir::SortFlag::IgnoreCase);

    qDebug("Fetched files %u", fileInfoList.size());

    endResetModel();
}

void ContentsModel::parentDir()
{
    auto d = QDir(m_currentDir);
    d.cdUp();
    setCurrentDir(d.absolutePath());
}

void ContentsModel::cellDoubleClicked(QPoint point)
{
    const QFileInfo& fi = fileInfoList.at(point.y());

    if (fi.isDir())
    {
        auto d = QDir(m_currentDir);
        setCurrentDir(d.absoluteFilePath(fi.fileName()));
    }
    else
    {
        // shell execute
    }
}
