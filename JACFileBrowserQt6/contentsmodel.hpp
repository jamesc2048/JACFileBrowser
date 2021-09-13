#ifndef CONTENTSMODEL_HPP
#define CONTENTSMODEL_HPP

#include <QAbstractListModel>
#include <QDir>

enum class ContentRoles
{
    // TODO
};

enum class ContentFlags : uint8_t
{
    IsSelected  = 1 << 0,
    // unused but for future?
    IsCut       = 1 << 1,
    IsCopied    = 1 << 2,
};

class ContentsModel : public QAbstractListModel
{
    Q_OBJECT

    static inline const QHash<int, QByteArray> roles = {
        { Qt::UserRole + 0, "Name" },
        { Qt::UserRole + 1, "Size" },
        { Qt::UserRole + 2, "IsDir" },
        { Qt::UserRole + 3, "AbsolutePath" },
        { Qt::UserRole + 4, "LastModified" },
        { Qt::UserRole + 5, "IsSelected" },
    };

    QFileInfoList contents;
    QList<uint8_t> contentFlags;

    QLocale locale;

    QString m_currentDir;
    Q_PROPERTY(QString currentDir READ currentDir WRITE setCurrentDir NOTIFY currentDirChanged)



public:
    explicit ContentsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    Q_INVOKABLE void loadDirectory(QString path);
    Q_INVOKABLE void clearSelection();

    const QString &currentDir() const;
    void setCurrentDir(const QString &newCurrentDir);

signals:
    void currentDirChanged();
};

#endif // CONTENTSMODEL_HPP
