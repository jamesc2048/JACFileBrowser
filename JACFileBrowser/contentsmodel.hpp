
#ifndef CONTENTSMODEL_H
#define CONTENTSMODEL_H

#include <QtQml>
#include <QAbstractListModel>
#include <QFileInfo>
#include <QDir>

enum class ModelMode
{
    List,
    Table
};

class ContentsModel : public QAbstractItemModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_ENUM(ModelMode)
    Q_PROPERTY(ModelMode modelMode READ modelMode WRITE setModelMode NOTIFY modelModeChanged)
    ModelMode m_modelMode = ModelMode::Table;

    Q_PROPERTY(QString currentDir READ currentDir WRITE setCurrentDir NOTIFY currentDirChanged)
    QString m_currentDir;

    QFileInfoList fileInfoList;

public:
    explicit ContentsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;
    QModelIndex index(int row, int column, const QModelIndex &parent) const override;
    QModelIndex parent(const QModelIndex &child) const override;

    // Properties
    ModelMode modelMode() const;
    void setModelMode(ModelMode newModelMode);
    QString currentDir() const;
    void setCurrentDir(const QString &newCurrentDir);

    // Invokables
    Q_INVOKABLE void parentDir();
    Q_INVOKABLE void cellDoubleClicked(QPoint point);

signals:
    void modelModeChanged();
    void currentDirChanged();

};

#endif // CONTENTSMODEL_H
