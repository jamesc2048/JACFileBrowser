#include "backend.hpp"

Backend::Backend(QObject *parent) : QObject(parent)
{
    mTabsModel = new TabsModel(parent);
}
