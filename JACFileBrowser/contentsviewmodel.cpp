#include "contentsviewmodel.hpp"

ContentsViewModel::ContentsViewModel(QFileInfo fi)
{
    set_name(fi.fileName());
    set_isDir(fi.isDir());
}

