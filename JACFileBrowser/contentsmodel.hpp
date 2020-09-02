#ifndef CONTENTSMODEL_HPP
#define CONTENTSMODEL_HPP

#include <QObject>
#include <QAbstractListModel>
#include <QDir>
#include <QDebug>

class ContentsModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(QString path MEMBER mPath NOTIFY pathChanged)

    QString mPath;
    QVector<bool> isSelectedList;
    QFileInfoList fileInfoList;

public:
    explicit ContentsModel(QString path, QObject *parent = nullptr);

    enum ContentsRoles
    {
        nameRole = Qt::UserRole + 1,
        isSelectedRole = nameRole + 1,
        isFolderRole = isSelectedRole + 1,
        sizeRole = isFolderRole + 1,
        absolutePathRole = sizeRole + 1
    };

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    void loadFiles();

signals:
    void pathChanged(QString path);
};

#endif // CONTENTSMODEL_HPP
