#include "explorertabviewmodel.hpp"

ExplorerTabViewModel::ExplorerTabViewModel(QObject* parent) : ViewModelBase(parent)
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
    set_currentPath("D:\\Amazon\\read");
#else
    set_currentPath("/");
#endif
}

void ExplorerTabViewModel::refreshFilesAndDirs()
{
    QFuture<QList<ContentsViewModel *>> fut =
        QtConcurrent::run([this]() {
            set_isRefreshing(true);

            QList<ContentsViewModel *> currentContents;

            QDir dir { get_currentPath() };

            QFileInfoList contents = dir.entryInfoList(QStringList(), QDir::Filter::NoFilter, QDir::SortFlag::DirsFirst);

            for (const auto& fi : contents)
            {
                auto vm = new ContentsViewModel(fi);
                vm->moveToThread(QGuiApplication::instance()->thread());
                currentContents << vm;
            }

            //QThread::sleep(5);
            //qDebug() << "Files" << contents;

            return currentContents;
        });

        auto watcher = new QFutureWatcher<QList<ContentsViewModel *>>();

        connect(watcher, &QFutureWatcher<QList<ContentsViewModel *>>::finished, [=]() {
            qDebug() << "future end";

            // Have to do this on main thread
            get_currentContents()->clear();
            get_currentContents()->append(watcher->result());
            watcher->deleteLater();
            set_isRefreshing(false);
        });

        watcher->setFuture(fut);
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
