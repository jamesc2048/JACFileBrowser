#include <QtQml>
#include <QSortFilterProxyModel>

class SortModel : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QAbstractItemModel* model READ model WRITE setModel NOTIFY modelChanged)

public:
    QAbstractItemModel *model() const;
    void setModel(QAbstractItemModel *newModel);

    // Need foward to QML as the functions in the base class are not Q_INVOKABLE
    Q_INVOKABLE int sortColumn() const;
    Q_INVOKABLE Qt::SortOrder sortOrder() const;
    Q_INVOKABLE void select(QPoint point, bool isCtrlPressed, bool isShiftPressed);

signals:
    void modelChanged();

private:
    QAbstractItemModel *m_model = nullptr;
    bool lessThan(const QModelIndex &sourceLeft, const QModelIndex &sourceRight) const override;
};
