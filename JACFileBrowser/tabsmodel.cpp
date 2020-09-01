#include "tabsmodel.hpp"

TabsModel::TabsModel(QObject* parent) : QAbstractListModel(parent)
{


    mContentsModelList << new ContentsModel("D:\\Useful Apps\\test", this);
    mContentsModelList << new ContentsModel("C:\\", this);
    mContentsModelList << new ContentsModel("D:\\", this);
}

int TabsModel::rowCount(const QModelIndex &parent) const
{
    return mContentsModelList.size();
}

QVariant TabsModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();

    switch (role)
    {
        case pathRole:
            return "path";
            break;

        case contentsModelRole:
            return "contents";//mContentsModelList.at(row);
            break;

        default:
            return "Unknown role";
    }
}

QHash<int, QByteArray> TabsModel::roleNames() const
{
    return {
        { pathRole, "path" },
        { contentsModelRole, "contentsModel" }
    };
}
