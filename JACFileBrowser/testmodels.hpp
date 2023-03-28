
#ifndef TESTMODELS_HPP
#define TESTMODELS_HPP
#include <QtQml>
#include <QAbstractTableModel>
#include <QAbstractListModel>

class TestListModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int rows MEMBER m_rows)

    int m_rows = 10;

public:
    TestListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
};

class TestTableModel : public QAbstractTableModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int rows MEMBER m_rows)
    Q_PROPERTY(int columns MEMBER m_columns)

    int m_rows = 10;
    int m_columns = 10;

public:
    TestTableModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const override;
    int columnCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;
};

#endif // TESTMODELS_HPP
