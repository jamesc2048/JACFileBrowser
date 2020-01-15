#ifndef MAINVIEWMODEL_HPP
#define MAINVIEWMODEL_HPP

#include "pch.hpp"

#include "explorertabviewmodel.hpp"

class MainViewModel : public ViewModelBase
{
    Q_OBJECT

    QML_READONLY_PROPERTY(QQmlObjectListModel<ExplorerTabViewModel> *, explorerTabs)

public:
    explicit MainViewModel(QObject *parent = nullptr);

signals:

public slots:
};

#endif // MAINVIEWMODEL_HPP
