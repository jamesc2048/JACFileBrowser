#ifndef CONTENTMODEL_HPP
#define CONTENTMODEL_HPP

#include <QObject>
#include <QAbstractListModel>
#include <QFileInfo>

class ContentModel : public QAbstractListModel
{
    Q_OBJECT

    static constexpr int nameRole = Qt::UserRole + 1;
    static constexpr int isDirRole = nameRole + 1;
    static constexpr int urlRole = isDirRole + 1;
    static constexpr int absolutePathRole = urlRole + 1;
    static constexpr int isSelectedRole = absolutePathRole + 1;

    static inline QHash<int, QByteArray> roleNamesMap = {
        { nameRole, "name" },
        { isDirRole, "isDir" },
        { urlRole, "url" },
        { absolutePathRole, "absolutePath" },
        { isSelectedRole, "isSelected" },
    };

    QList<QFileInfo> mContents;
    QString mPath;
    QList<bool> mIsSelectedList;

    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)

public:
    explicit ContentModel(QObject *parent = nullptr);
    QString path();
    void setPath(QString path);

signals:
    void pathChanged();

public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
};

#endif // CONTENTMODEL_HPP
