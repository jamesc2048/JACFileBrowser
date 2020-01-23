#ifndef MAINVIEWMODEL_HPP
#define MAINVIEWMODEL_HPP

#include "pch.hpp"

#include "explorertabviewmodel.hpp"

class MainViewModel : public ViewModelBase
{
    Q_OBJECT

    QML_WRITABLE_PROPERTY(int, currentTabIndex)
    QML_READONLY_PROPERTY(QQmlObjectListModel<ExplorerTabViewModel> *, explorerTabs)
    QML_WRITABLE_PROPERTY(bool, isCtrlPressed)

public:
    explicit MainViewModel(QObject *parent = nullptr);

    Q_INVOKABLE void openNewTab();
    Q_INVOKABLE void closeCurrentTab();
};

#endif // MAINVIEWMODEL_HPP
