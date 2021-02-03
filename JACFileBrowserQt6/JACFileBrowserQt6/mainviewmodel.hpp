#ifndef MAINVIEWMODEL_HPP
#define MAINVIEWMODEL_HPP

#include <QObject>
#include <QAbstractListModel>

#include "contentmodel.hpp"

class MainViewModel : public QObject
{
    Q_OBJECT

    QAbstractListModel* driveModel;
    QAbstractListModel* contentModel;

public:
    explicit MainViewModel(QObject *parent = nullptr);

   // Q_PROPERTY(QAbstractListModel* driveModel MEMBER driveModel)
    Q_PROPERTY(QAbstractListModel* contentModel MEMBER contentModel)

signals:


};

#endif // MAINVIEWMODEL_HPP
