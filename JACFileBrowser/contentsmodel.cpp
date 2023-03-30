#include "contentsmodel.hpp"

#include <QtConcurrent>
#include <QLocale>
#include <QDir>

#ifdef Q_OS_WIN
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <Windows.h>
#include <shellapi.h>
#endif


using namespace Qt::Literals::StringLiterals;

ContentsModel::ContentsModel(QObject *parent)
    : QAbstractTableModel(parent)
{
}

int ContentsModel::rowCount(const QModelIndex &parent) const
{
    return (int)fileInfoList.size();
}

int ContentsModel::columnCount(const QModelIndex &parent) const
{
    // Filename, Date Modified, Type, Size
    return 4;
}

QVariant ContentsModel::data(const QModelIndex &index, int role) const
{
    static const QLocale locale;

    if (!index.isValid())
    {
        return {};
    }

    const int row = index.row();
    const int col = index.column();

    const QFileInfo &fi = fileInfoList.at(row);

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
            return fi.lastModified().toString(u"dd/MM/yyyy hh:mm"_qs);
        case 2:
            // Type
            // TODO
            return fi.isFile() ? u"File"_qs : u"Directory"_qs;
        case 3:
            // Size
            return fi.isFile() ?
                        locale.toString(ceil(fi.size() / 1024.)) + u" KB"_qs :
                        u""_qs;
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
    }

    // List mode: map to columns
    // Or maybe it should be done the other way round? Roles first, mapping to columns?
    // Have a think about this
    if (role > Qt::UserRole)
    {
        switch (role)
        {
            // case ContentsModel::FileNameRole:
            //return data(createIndex(row, 0), Qt::DisplayRole);
        }

        // TODO
        // filename
        // last modified
        // type
        // size
    }

    return u"Invalid Data"_qs;
}

QHash<int, QByteArray> ContentsModel::roleNames() const
{
    return {
        { Qt::DisplayRole, "display"_qba },
        { ContentsModel::IsFileRole, "isFile"_qba },
        { ContentsModel::FileSizeRole, "fileSize"_qba },
        { ContentsModel::LastModifiedRole, "lastModified"_qba },
    };
}

QVariant ContentsModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    static const QString headers[] = { u"Name"_qs, u"Date Modified"_qs, u"Type"_qs, u"Size"_qs };

    if (role == Qt::DisplayRole && section >= 0 && section <= sizeof headers)
    {
        return headers[section];
    }

    return "Unknown header";
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

    auto d = QDir(m_currentDir);
    QString clickedPath = d.absoluteFilePath(fi.fileName());

    if (fi.isDir())
    {
        setCurrentDir(clickedPath);
    }
    else
    {
// TODO mac and linux
#ifdef Q_OS_WIN
        ShellExecuteW(nullptr, L"open", clickedPath.toStdWString().c_str(), nullptr, nullptr, SW_SHOW);
#endif
    }
}

