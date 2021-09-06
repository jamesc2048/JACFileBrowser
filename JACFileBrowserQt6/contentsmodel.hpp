#ifndef CONTENTSMODEL_HPP
#define CONTENTSMODEL_HPP

#include <QAbstractListModel>
#include <QDir>

class ContentsModel : public QAbstractListModel
{
    Q_OBJECT

    static inline const QHash<int, QByteArray> roles = {
        { Qt::UserRole + 0, "Name" },
        { Qt::UserRole + 1, "Size" },
        { Qt::UserRole + 2, "IsDir" },
        { Qt::UserRole + 3, "Absolute Path" },
    };

    QFileInfoList contents;

public:
    explicit ContentsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void loadDirectory(QString path);
};

#endif // CONTENTSMODEL_HPP
