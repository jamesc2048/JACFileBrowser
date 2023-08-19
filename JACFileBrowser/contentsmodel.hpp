
#ifndef CONTENTSMODEL_H
#define CONTENTSMODEL_H

#include <QtQml>
#include <QAbstractTableModel>
#include <QFileInfo>
#include <QFileIconProvider>
#include <QFileSystemWatcher>

// IDEA for "universal model":
// Provide mapping to columns from roleNames.
// So for example all columns can be accessed from roleNames.
// Avoids duplication of code.
class ContentsModel : public QAbstractTableModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString currentDir READ currentDir WRITE setCurrentDir NOTIFY currentDirChanged FINAL)
    Q_PROPERTY(int rows READ rows NOTIFY rowsChanged FINAL)
    Q_PROPERTY(QUrl lastSelectedUrl MEMBER m_lastSelectedUrl NOTIFY lastSelectedUrlChanged FINAL)
    Q_PROPERTY(bool isLoading MEMBER m_isLoading NOTIFY isLoadingChanged FINAL)

    QString m_currentDir;
    QFileInfoList m_fileInfoList;
    // For use in UI to avoid a linear search everytime a delegate is rendered
    QList<bool> m_selectionList;
    // Stores the actually selected indices for convenience when an operation is actually selected (copying, pasting etc)
    // Or maybe use a custom struct copied around to hold all the selections?
    QList<uint32_t> m_selectionIndices;

    QFileIconProvider iconProvider;

public:
    enum Roles
    {
        IsFileRole = Qt::UserRole + 1,
        FileSizeRole = Qt::UserRole + 2,
        LastModifiedRole = Qt::UserRole + 3,
        AbsolutePathRole = Qt::UserRole + 4,
        IsSelectedRole = Qt::UserRole + 5,
    };

    explicit ContentsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    // Properties
    QString currentDir() const;
    void setCurrentDir(const QString &newCurrentDir);
    int rows() const;

    // Invokables
    Q_INVOKABLE void parentDir();
    Q_INVOKABLE void cellDoubleClicked(QPoint point);

    void deselectAll();

signals:
    void currentDirChanged();
    void rowsChanged();
    void lastSelectedUrlChanged();
    void isLoadingChanged();

private:
    QUrl m_lastSelectedUrl;
    bool m_isLoading = false;
};

#endif // CONTENTSMODEL_H
