#ifndef TABSMODEL_HPP
#define TABSMODEL_HPP

#include <QAbstractListModel>

#include <contentsmodel.hpp>

class TabsModel : public QAbstractListModel
{
    Q_OBJECT

    static constexpr int pathRole = Qt::UserRole + 1;
    static constexpr int contentsModelRole = pathRole + 1;

    QList<ContentsModel *> mContentsModelList;

public:
    TabsModel(QObject *parent = nullptr);

public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

signals:
    void pathChanged(QString path);
};

#endif // TABSMODEL_HPP
