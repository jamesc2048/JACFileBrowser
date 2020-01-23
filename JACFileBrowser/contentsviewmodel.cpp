#include "contentsviewmodel.hpp"

ContentsViewModel::ContentsViewModel(QFileInfo fi, QObject* parent) : ViewModelBase(parent)
{
    set_name(fi.fileName());
    set_isDir(fi.isDir());
}

