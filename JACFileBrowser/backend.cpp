#include "backend.hpp"

Backend::Backend(QObject *parent) : QObject(parent)
{
    mTabsModel = new TabsModel(parent);
}

void Backend::newTab(int index)
{
    TabsModel* model = qobject_cast<TabsModel *>(mTabsModel);

    model->addTab(index);
}

void Backend::closeTab(int index)
{
    TabsModel* model = qobject_cast<TabsModel *>(mTabsModel);

    model->removeTab(index);
}
