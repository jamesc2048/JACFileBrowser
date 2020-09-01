#ifndef BACKEND_HPP
#define BACKEND_HPP

#include <QObject>
#include "tabsmodel.hpp"

class Backend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QObject* tabsModel MEMBER mTabsModel NOTIFY tabsModelChanged)

    QObject* mTabsModel;

public:
    explicit Backend(QObject *parent = nullptr);

signals:
    void tabsModelChanged(QObject* tabsModel);
};

#endif // BACKEND_HPP
