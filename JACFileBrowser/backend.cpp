#include "backend.hpp"

Backend::Backend(QObject *parent) : QObject(parent)
{
    mTabsModel = new TabsModel(parent);
    mDrivesModel = new DrivesModel(parent);
}

void Backend::newTab(int index)
{
    mTabsModel->addTab(index);
}

void Backend::closeTab(int index)
{
    mTabsModel->removeTab(index);
}

bool Backend::openAction(int tabIndex, int contentIndex)
{
    const QVariant contentsVariant = mTabsModel->data(mTabsModel->index(tabIndex), TabsModel::contentsModelRole);
    ContentsModel* contentsModel = contentsVariant.value<ContentsModel *>();

    if (contentsModel)
    {
        const bool isDir = contentsModel->data(contentsModel->index(contentIndex), ContentsModel::isFolderRole)
                        .toBool();

        const QString localPath = contentsModel->data(contentsModel->index(contentIndex), ContentsModel::absolutePathRole)
                .toString();

        if (isDir)
        {
            contentsModel->setProperty("path", localPath);
        }
        else
        {
            // TODO open in internal viewer if supported
            return QDesktopServices::openUrl(QUrl::fromLocalFile(localPath));
        }
    }

    return false;
}

void Backend::navigateTab(int index, QString path)
{
    ContentsModel *contents = mTabsModel->data(mTabsModel->index(index), TabsModel::contentsModelRole)
                                        .value<ContentsModel *>();

    contents->setPath(path);
}
