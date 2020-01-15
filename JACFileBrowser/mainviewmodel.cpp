#include "mainviewmodel.hpp"

MainViewModel::MainViewModel(QObject *parent) : ViewModelBase(parent)
{

    REGISTER_METATYPE(QQmlObjectListModel<ExplorerTabViewModel> *);

    set_explorerTabs(new QQmlObjectListModel<ExplorerTabViewModel>());

    get_explorerTabs()->append(new ExplorerTabViewModel());
    get_explorerTabs()->append(new ExplorerTabViewModel());
    get_explorerTabs()->append(new ExplorerTabViewModel());
}
