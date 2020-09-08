#ifndef BACKEND_HPP
#define BACKEND_HPP

#include <QObject>
#include <QDesktopServices>
#include <QUrl>

#include "tabsmodel.hpp"
#include "drivesmodel.hpp"
#include "contentsmodel.hpp"

class Backend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(TabsModel* tabsModel MEMBER mTabsModel NOTIFY tabsModelChanged)
    Q_PROPERTY(DrivesModel* drivesModel MEMBER mDrivesModel)

    TabsModel* mTabsModel;
    DrivesModel* mDrivesModel;

public:
    explicit Backend(QObject *parent = nullptr);

    Q_INVOKABLE void newTab(int index);
    Q_INVOKABLE void closeTab(int index);
    Q_INVOKABLE bool openAction(int tabIndex, int contentIndex);
    Q_INVOKABLE void navigateTab(int index, QString path);

signals:
    void tabsModelChanged(QObject* tabsModel);
};

#endif // BACKEND_HPP
