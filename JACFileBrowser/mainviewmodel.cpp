#include "mainviewmodel.hpp"

MainViewModel::MainViewModel(QObject *parent) : ViewModelBase(parent)
{

    REGISTER_METATYPE(QQmlObjectListModel<ExplorerTabViewModel> *);

    set_explorerTabs(new QQmlObjectListModel<ExplorerTabViewModel>());

    openNewTab();
}

void MainViewModel::openNewTab()
{
    get_explorerTabs()->append(new ExplorerTabViewModel());
}

void MainViewModel::closeCurrentTab()
{
    if (get_explorerTabs()->count() > 1)
    {
        get_explorerTabs()->remove(get_currentTabIndex());
    }
}
