#ifndef CONTENTSMODEL_HPP
#define CONTENTSMODEL_HPP

#include <QObject>
#include <QAbstractListModel>
#include <QDir>

class ContentsModel : public QAbstractListModel
{
    Q_OBJECT

    static constexpr int nameRole = Qt::UserRole + 1;
    //static constexpr int nameRole = Qt::UserRole + 1;

    Q_PROPERTY(QString path MEMBER mPath NOTIFY pathChanged)

    QString mPath;
    QVector<bool> isSelectedList;
    QFileInfoList fileInfoList;

public:
    explicit ContentsModel(QString path, QObject *parent = nullptr);


signals:
    void pathChanged(QString path);

public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // CONTENTSMODEL_HPP
