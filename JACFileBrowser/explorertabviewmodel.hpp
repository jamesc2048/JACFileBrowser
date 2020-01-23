#ifndef EXPLORERTABVIEWMODEL_HPP
#define EXPLORERTABVIEWMODEL_HPP

#include "common.hpp"

#include "contentsviewmodel.hpp"

class ExplorerTabViewModel : public ViewModelBase
{
    Q_OBJECT

    QML_READONLY_PROPERTY(int, tabId)
    QML_READONLY_PROPERTY(bool, isRefreshing)
    QML_READONLY_PROPERTY(QString, name)
    QML_READONLY_PROPERTY(QString, currentPath)
    QML_READONLY_PROPERTY(QQmlObjectListModel<ContentsViewModel> *, currentContents)

    QDir currentPathDir;
    void refreshFilesAndDirs();

public:
    ExplorerTabViewModel(QObject *parent = nullptr);

    Q_INVOKABLE void contentDoubleClick(int i);
};

#endif // EXPLORERTABVIEWMODEL_HPP
