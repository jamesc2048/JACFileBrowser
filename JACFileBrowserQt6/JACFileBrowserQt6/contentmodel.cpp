#include "contentmodel.hpp"

#include <QDir>
#include <QUrl>
#include <QGuiApplication>

#ifdef _WIN32
#include <Windows.h>
#endif

ContentModel::ContentModel(QObject *parent) : QAbstractListModel(parent)
{
}

QString ContentModel::path()
{
    return mPath;
}

void ContentModel::setPath(QString path)
{
    mPath = path;
    emit pathChanged();

    beginResetModel();

    mContents = QDir(path).entryInfoList(QDir::Filter::AllEntries | QDir::Filter::NoDotAndDotDot,
                                         QDir::SortFlag::DirsFirst);
    mIsSelectedList.resize(mContents.size());
    // assuming boolean 1 byte
    memset(mIsSelectedList.data(), 0, mIsSelectedList.size());

    endResetModel();
}

void ContentModel::itemDoubleClicked(int index)
{
    bool isDir = mContents[index].isDir();
    QString absPath = mContents[index].absoluteFilePath();

    if (isDir)
    {
        setPath(absPath);
    }
    else
    {
#ifdef _WIN32
        ShellExecuteA(nullptr, nullptr, qPrintable(absPath), nullptr, nullptr, 0);
#endif
    }
}

void ContentModel::toggleSelect(int i)
{
    if (QGuiApplication::keyboardModifiers() & Qt::ControlModifier)
    {
        setData(index(i), !mIsSelectedList[i], isSelectedRole);
    }
    else
    {
        // is there a more efficient way?
        for (int j = 0; j < mIsSelectedList.size(); j++)
        {
            setData(index(j), false, isSelectedRole);
        }

        setData(index(i), true, isSelectedRole);
    }

}

int ContentModel::rowCount(const QModelIndex &parent) const
{
    return mContents.length();
}

QVariant ContentModel::data(const QModelIndex &index, int role) const
{
    switch (role)
    {
        case nameRole:
            return mContents[index.row()].fileName();

        case isDirRole:
            return mContents[index.row()].isDir();

        case urlRole:
            return QUrl::fromLocalFile(data(index, absolutePathRole).toString());

        case absolutePathRole:
            return mContents[index.row()].absoluteFilePath();

        case isSelectedRole:
            return mIsSelectedList[index.row()];

        default:
            return "(unknown role)";
    }
}

QVariant ContentModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return role;
}

Qt::ItemFlags ContentModel::flags(const QModelIndex &index) const
{
    return Qt::ItemNeverHasChildren | Qt::ItemIsSelectable | Qt::ItemIsEditable;
}

QHash<int, QByteArray> ContentModel::roleNames() const
{
    return roleNamesMap;
}

bool ContentModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    switch (role)
    {
        case isSelectedRole:
            mIsSelectedList[index.row()] = value.toBool();
            emit dataChanged(index, index, { isSelectedRole });
            return true;

        default:
            return false;
    }
}
