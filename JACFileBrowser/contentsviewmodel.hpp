#ifndef FILEVIEWMODEL_HPP
#define FILEVIEWMODEL_HPP

#include "pch.hpp"

class ContentsViewModel : public ViewModelBase
{
    Q_OBJECT

    QML_WRITABLE_PROPERTY(QString, name)
    QML_WRITABLE_PROPERTY(bool, isDir)
    QML_WRITABLE_PROPERTY(bool, isSelected)

public:  
    ContentsViewModel(QFileInfo fi, QObject *parent = nullptr);
};

#endif // FILEVIEWMODEL_HPP
