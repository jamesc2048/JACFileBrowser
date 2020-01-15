#ifndef EXPLORERTABVIEWMODEL_HPP
#define EXPLORERTABVIEWMODEL_HPP

#include "pch.hpp"

#include "contentsviewmodel.hpp"

class ExplorerTabViewModel : public ViewModelBase
{
    Q_OBJECT

    QML_READONLY_PROPERTY(QString, name)
    QML_READONLY_PROPERTY(QString, currentPath)
    QML_READONLY_PROPERTY(QQmlObjectListModel<ContentsViewModel> *, currentContents)

    void refreshFilesAndDirs();

public:
    ExplorerTabViewModel();

    Q_INVOKABLE void contentDoubleClick(int i);
};

#endif // EXPLORERTABVIEWMODEL_HPP
