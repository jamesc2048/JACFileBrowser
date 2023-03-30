#include <QtQml>
#include <QSortFilterProxyModel>

class SortModel : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QAbstractItemModel* model READ model WRITE setModel NOTIFY modelChanged);
    Q_PROPERTY(int sortColumn READ sortColumn)
    Q_PROPERTY(Qt::SortOrder sortOrder READ sortOrder)

public:
    QAbstractItemModel *model() const;
    void setModel(QAbstractItemModel *newModel);

    int sortColumn() const
    {
        return QSortFilterProxyModel::sortColumn();
    }

    Qt::SortOrder sortOrder() const
    {
        return QSortFilterProxyModel::sortOrder();
    };

signals:
    void modelChanged();

private:
    QAbstractItemModel *m_model = nullptr;
    bool lessThan(const QModelIndex &sourceLeft, const QModelIndex &sourceRight) const override;
};
