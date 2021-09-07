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
        { Qt::UserRole + 4, "Last Modified" },
    };

    QFileInfoList contents;

    Q_PROPERTY(QString currentDir READ currentDir WRITE setCurrentDir NOTIFY currentDirChanged)

    QString m_currentDir;

public:
    explicit ContentsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void loadDirectory(QString path);

    const QString &currentDir() const;
    void setCurrentDir(const QString &newCurrentDir);

signals:
    void currentDirChanged();
};

#endif // CONTENTSMODEL_HPP
