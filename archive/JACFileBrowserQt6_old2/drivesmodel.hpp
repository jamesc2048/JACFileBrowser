#ifndef DRIVESMODEL_HPP
#define DRIVESMODEL_HPP

#include <QAbstractListModel>
#include <QDir>

class DrivesModel : public QAbstractListModel
{
    Q_OBJECT

    struct Drive
    {
        QFileInfo fileInfo;
        QString name;
        bool isSpecialFolder;
    };

    QList<Drive> drives;

public:
    explicit DrivesModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // DRIVESMODEL_HPP
