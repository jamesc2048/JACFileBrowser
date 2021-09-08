#include "mainviewmodel.hpp"

MainViewModel::MainViewModel(QObject *parent) : QObject(parent)
{
    //driveModel = new DriveModel(parent);
    contentModel = new ContentModel(parent);
}
