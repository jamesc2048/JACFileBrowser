
#ifndef DRIVESMODEL_HPP
#define DRIVESMODEL_HPP

#include <QtQml>
#include <QAbstractListModel>
#include <QStorageInfo>

class DrivesModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

    QList<QStorageInfo> m_drives;

    Q_PROPERTY(int rows READ rows NOTIFY rowsChanged)

public:
    enum Roles
    {
        RootPathRole = Qt::UserRole + 1
    };

    explicit DrivesModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    int rows() const;
signals:
    void rowsChanged();
};

#endif // DRIVESMODEL_HPP
