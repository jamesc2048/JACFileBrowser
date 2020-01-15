#include "explorertabviewmodel.hpp"

ExplorerTabViewModel::ExplorerTabViewModel()
{
    REGISTER_METATYPE(QQmlObjectListModel<ContentsViewModel>*);

    set_currentContents(new QQmlObjectListModel<ContentsViewModel>());
    set_name("New tab");

    connect(this, &ExplorerTabViewModel::propertyChanged, [this](QString propName) {
        if (propName == "currentPath")
        {
            qDebug() << "Change Path to " << get_currentPath();

            refreshFilesAndDirs();
        }
    });

    set_currentPath("D:\\");
}

void ExplorerTabViewModel::refreshFilesAndDirs()
{
    get_currentContents()->clear();

    QDir dir { get_currentPath() };

    QFileInfoList contents = dir.entryInfoList(QStringList(), QDir::Filter::NoFilter, QDir::SortFlag::DirsFirst);

    for (const auto& fi : contents)
    {
        get_currentContents()->append(new ContentsViewModel(fi));
    }

    qDebug() << "Files" << contents;
}

void ExplorerTabViewModel::contentDoubleClick(int i)
{
    ContentsViewModel* vm = get_currentContents()->at(i);

    if (vm->get_isDir())
    {
        // TODO use proper path join
        set_currentPath(get_currentPath() + "\\" + vm->get_name());
    }
    else
    {
        QProcess::startDetached(get_currentPath() + "\\" + vm->get_name());
    }
}
