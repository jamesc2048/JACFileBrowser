#ifndef FILEVIEWMODEL_HPP
#define FILEVIEWMODEL_HPP

#include "pch.hpp"

class ContentsViewModel : public ViewModelBase
{
    Q_OBJECT

    QML_WRITABLE_PROPERTY(QString, name)
    QML_WRITABLE_PROPERTY(bool, isDir)
public:
    ContentsViewModel(QFileInfo fi);
};

#endif // FILEVIEWMODEL_HPP
