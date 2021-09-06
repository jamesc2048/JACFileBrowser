#ifndef DRIVESMODEL_HPP
#define DRIVESMODEL_HPP

#include <QAbstractListModel>
#include <QDir>

class DrivesModel : public QAbstractListModel
{
    Q_OBJECT

    QFileInfoList drives;

public:
    explicit DrivesModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
};

#endif // DRIVESMODEL_HPP
