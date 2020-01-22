#include "explorertabviewmodel.hpp"

ExplorerTabViewModel::ExplorerTabViewModel()
{
    REGISTER_METATYPE(QQmlObjectListModel<ContentsViewModel>*);

    set_currentContents(new QQmlObjectListModel<ContentsViewModel>(this));
    set_name("New tab");

    connect(this, &ExplorerTabViewModel::propertyChanged, [this](QString propName) {
        if (propName == "currentPath")
        {
            qDebug() << "Change Path to " << get_currentPath();
            set_name(QString("New tab %1").arg(get_currentPath()));

            currentPathDir = QDir(get_currentPath());
            refreshFilesAndDirs();
        }
    });

#ifdef _WIN32
    set_currentPath("D:\\");
#else
    set_currentPath("/");
#endif
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

    QString fullPath = QDir::cleanPath(currentPathDir.filePath(vm->get_name()));

    if (vm->get_isDir())
    {
        // TODO use proper path join
        set_currentPath(fullPath);
    }
    else
    {
        QString quoted = QString("\"%1\"").arg(fullPath);
        std::system(quoted.toLocal8Bit().data());
    }
}
