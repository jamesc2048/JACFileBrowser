#include "contentsviewmodel.hpp"

ContentsViewModel::ContentsViewModel(QFileInfo fi)
{
    set_name(fi.baseName());
    set_isDir(fi.isDir());
}

