
#ifndef CONTENTSMODEL_H
#define CONTENTSMODEL_H

#include <QtQml>
#include <QAbstractTableModel>
#include <QFileInfo>

// IDEA for "universal model":
// Provide mapping to columns from roleNames.
// So for example all columns can be accessed from roleNames.
// Avoids duplication of code.
class ContentsModel : public QAbstractTableModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString currentDir READ currentDir WRITE setCurrentDir NOTIFY currentDirChanged)
    Q_PROPERTY(int rows READ rows NOTIFY rowsChanged)

    QString m_currentDir;
    QFileInfoList m_fileInfoList;

public:
    enum Roles
    {
        IsFileRole = Qt::UserRole + 1,
        FileSizeRole = Qt::UserRole + 2,
        LastModifiedRole = Qt::UserRole + 3
    };

    explicit ContentsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;

    // Properties
    QString currentDir() const;
    void setCurrentDir(const QString &newCurrentDir);
    int rows() const;

    // Invokables
    Q_INVOKABLE void parentDir();
    Q_INVOKABLE void cellDoubleClicked(QPoint point);

signals:
    void currentDirChanged();
    void rowsChanged();
};

#endif // CONTENTSMODEL_H
