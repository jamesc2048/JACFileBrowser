#include "tabsmodel.hpp"

TabsModel::TabsModel(QObject* parent) : QAbstractListModel(parent)
{
    //mContentsModelList << new ContentsModel("D:\\Useful Apps\\test", this);
    mContentsModelList << new ContentsModel("C:\\", this);
    mContentsModelList << new ContentsModel("D:\\", this);
}

int TabsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mContentsModelList.size();
}

QVariant TabsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
    {
        return "Invalid index";
    }

    const int row = index.row();

    switch (role)
    {
//        case pathRole:
//            return mContentsModelList.at(row)->property("path");
//            break;

        case contentsModelRole:
            return QVariant::fromValue(mContentsModelList.at(row));
            break;

        default:
            return "Unknown role";
    }
}

QHash<int, QByteArray> TabsModel::roleNames() const
{
    return
    {
        { pathRole, "path" },
        { contentsModelRole, "contentsModel" }
    };
}

void TabsModel::addTab(int index)
{
    beginInsertRows(QModelIndex(), index, index);

    mContentsModelList.insert(index, new ContentsModel("C:\\", this));

    endInsertRows();
}

void TabsModel::removeTab(int index)
{
    beginRemoveRows(QModelIndex(), index, index);

    mContentsModelList.removeAt(index);

    endRemoveRows();
}
