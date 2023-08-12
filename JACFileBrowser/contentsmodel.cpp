#include "contentsmodel.hpp"

#include <QtConcurrent>
#include <QLocale>
#include <QDir>
#include <QDesktopServices>

#ifdef Q_OS_WIN
#define WIN32_LEAN_AND_MEAN
#include <Windows.h>
#include <shellapi.h>
#endif

#include "utilities.hpp"

using namespace Qt::Literals::StringLiterals;

ContentsModel::ContentsModel(QObject *parent)
    : QAbstractTableModel(parent)
{
}

int ContentsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return (int)m_fileInfoList.size();
}

int ContentsModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    // Filename, Date Modified, Type, Size
    return 4;
}

QVariant ContentsModel::data(const QModelIndex &index, int role) const
{
    //qDebug() << "Data for index" << index << "role" << role;
    static const QLocale locale;

    if (!index.isValid())
    {
        return {};
    }

    const int row = index.row();
    const int col = index.column();

    const QFileInfo &fi = m_fileInfoList.at(row);

    // Table mode
    if (role == Qt::DisplayRole)
    {
        switch (col)
        {
        case 0:
            // Filename
            return fi.fileName();
        case 1:
            // Last Modified
            return fi.lastModified().toString(u"dd/MM/yyyy hh:mm"_s);
        case 2:
            // Type
            return fi.isFile() ? u"File"_s : u"Directory"_s;
        case 3:
            // Size
            return fi.isFile() ?
                        locale.toString(ceil(fi.size() / 1024.), 'f', 0) + u" KB"_s :
                        u""_s;
        default:
            return "Unknown";
        }
    }

    // Roles which apply to both table and list mode
    switch (role)
    {
    case ContentsModel::IsFileRole:
        return fi.isFile();
    case ContentsModel::FileSizeRole:
        return fi.size();
    case ContentsModel::LastModifiedRole:
        return fi.lastModified();
    case ContentsModel::IsSelectedRole:
        return m_selectionList.at(row);
    }

    // List mode: map to columns
    // Or maybe it should be done the other way round? Roles first, mapping to columns?
    // Have a think about this
    if (role > Qt::UserRole)
    {
        //switch (role)
        //{
            // case ContentsModel::FileNameRole:
            //return data(this->index(row, 0), Qt::DisplayRole);
        //}

        // TODO
        // filename
        // last modified
        // type
        // size
    }

    return u"Invalid Data"_s;
}

QHash<int, QByteArray> ContentsModel::roleNames() const
{
    static QHash<int, QByteArray> roleNames =
    {
        { Qt::DisplayRole, "display"_ba },
        { ContentsModel::IsFileRole, "isFile"_ba },
        { ContentsModel::FileSizeRole, "fileSize"_ba },
        { ContentsModel::LastModifiedRole, "lastModified"_ba },
        { ContentsModel::IsSelectedRole, "isSelected"_ba },
    };

    return roleNames;
}

QVariant ContentsModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    Q_UNUSED(orientation)
    static const QString headers[] = { u"Name"_s, u"Date Modified"_s, u"Type"_s, u"Size"_s };

    if (role == Qt::DisplayRole && section >= 0 && section <= (int)sizeof headers)
    {
        return headers[section];
    }

    return "Unknown header";
}

bool ContentsModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid())
    {
        return false;
    }

    int row = index.row();

    switch (role)
    {
    case ContentsModel::IsSelectedRole:
    {
        if (row > m_selectionList.size())
        {
            return false;
        }

        m_lastSelectedUrl = QUrl::fromLocalFile(m_fileInfoList.at(row).absoluteFilePath());
        emit lastSelectedUrlChanged();

        m_selectionList[row] = value.toBool();
        // Invalidate entire tableview row to make selection rectangles redraw themselves in delegate
        auto begin = this->index(row, 0);
        auto end = this->index(row, columnCount() - 1);
        emit dataChanged(begin, end, { ContentsModel::IsSelectedRole });
        break;
    }
    default:
        return false;
    }

    return true;
}

QString ContentsModel::currentDir() const
{
    return m_currentDir;
}

void ContentsModel::setCurrentDir(const QString &newCurrentDir)
{
    m_currentDir = QDir::toNativeSeparators(newCurrentDir);
    emit currentDirChanged();

    QThreadPool::globalInstance()->start([&] {
        Utilities::runOnMainThread([this] {
            beginResetModel();
        });

        QDir dir(m_currentDir);

        qDebug("Fetch dir %s", qPrintable(dir.absolutePath()));

        m_fileInfoList = dir.entryInfoList(QDir::Filter::AllEntries | QDir::Filter::NoDotAndDotDot,
                                         QDir::SortFlag::DirsFirst | QDir::SortFlag::Name | QDir::SortFlag::IgnoreCase);

        m_selectionList = QList<bool>(m_fileInfoList.size());

        Utilities::runOnMainThread([this] {
            emit rowsChanged();
            endResetModel();
        });

        qDebug("Fetched files %lld", m_fileInfoList.size());
    });
}

void ContentsModel::parentDir()
{
    auto d = QDir(m_currentDir);
    d.cdUp();
    setCurrentDir(d.absolutePath());
}

void ContentsModel::cellDoubleClicked(QPoint point)
{
    if (point.y() < 0)
    {
        qWarning("Invalid point for double click: %d, %d", point.x(), point.y());
        return;
    }

    const QFileInfo& fi = m_fileInfoList.at(point.y());
    QString absPath = fi.absoluteFilePath();

    if (fi.isDir())
    {
        setCurrentDir(absPath);
    }
    else
    {
#ifdef Q_OS_WIN
        qDebug("Opening file %s using ShellExecute", qPrintable(absPath));
        ShellExecuteW(nullptr, L"open", absPath.toStdWString().c_str(), nullptr, nullptr, SW_SHOW);
#else
        qDebug("Opening file %s using QDesktopServices", qPrintable(absPath));
        QUrl url = QUrl::fromLocalFile(absPath);

        if (!QDesktopServices::openUrl(url))
        {
            qWarning("Couldn't open url %s", qPrintable(url.toString()));
        }
#endif
    }
}

void ContentsModel::deselectAll()
{
    // Bulk deselect everything (reset bool list to all false)
    memset(m_selectionList.data(), 0, m_selectionList.size());
    emit dataChanged(index(0, 0),
                    index(rowCount() - 1, columnCount() - 1),
                    { ContentsModel::IsSelectedRole });
}

int ContentsModel::rows() const
{
    return rowCount();
}
