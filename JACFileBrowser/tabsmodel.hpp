#ifndef TABSMODEL_HPP
#define TABSMODEL_HPP

#include <QAbstractListModel>

#include <contentsmodel.hpp>

class TabsModel : public QAbstractListModel
{
    Q_OBJECT

    QList<ContentsModel *> mContentsModelList;

public:
    enum TabRoles
    {
        pathRole = Qt::UserRole + 1,
        contentsModelRole = pathRole + 1
    };

    TabsModel(QObject *parent = nullptr);

    const QList<ContentsModel *>& getContentsModelList() { return mContentsModelList; }

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void addTab(int index);
    void removeTab(int index);
};

#endif // TABSMODEL_HPP
