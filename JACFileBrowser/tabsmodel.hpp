#ifndef TABSMODEL_HPP
#define TABSMODEL_HPP

#include <QAbstractListModel>

#include <contentsmodel.hpp>

class TabsModel : public QAbstractListModel
{
    Q_OBJECT

    enum TabRoles
    {
        pathRole = Qt::UserRole + 1,
        contentsModelRole = pathRole + 1
    };

    QList<QObject *> mContentsModelList;

public:
    TabsModel(QObject *parent = nullptr);

public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void addTab(int index);
    void removeTab(int index);

signals:
    void pathChanged(QString path);
};

#endif // TABSMODEL_HPP
