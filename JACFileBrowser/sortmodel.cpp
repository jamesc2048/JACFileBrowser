#include "sortmodel.hpp"
#include "contentsmodel.hpp"

QAbstractItemModel *SortModel::model() const
{
    return m_model;
}

void SortModel::setModel(QAbstractItemModel *newModel)
{
    if (m_model == newModel)
        return;
    m_model = newModel;

    setSourceModel(m_model);

    emit modelChanged();
}


bool SortModel::lessThan(const QModelIndex &sourceLeft, const QModelIndex &sourceRight) const
{
    bool isFileLeft = sourceModel()->data(sourceLeft, ContentsModel::IsFileRole).toBool();
    bool isFileRight = sourceModel()->data(sourceRight, ContentsModel::IsFileRole).toBool();

    // Always put dirs on top
    // Better way of doing this?
    if (sortOrder() == Qt::DescendingOrder)
    {
        if (isFileLeft < isFileRight)
        {
            return false;
        }
    }
    else
    {
        if (isFileLeft > isFileRight)
        {
            return false;
        }
    }

    // special case size: get fileSize role
    if (sourceLeft.column() == 3 && sourceRight.column() == 3)
    {
        int64_t dataLeft = sourceModel()->data(sourceLeft, ContentsModel::FileSizeRole).toLongLong();
        int64_t dataRight = sourceModel()->data(sourceRight, ContentsModel::FileSizeRole).toLongLong();

        return dataLeft < dataRight;
    }

    // special case size: get dateTime role
    if (sourceLeft.column() == 1 && sourceRight.column() == 1)
    {
        QDateTime dataLeft = sourceModel()->data(sourceLeft, ContentsModel::LastModifiedRole).toDateTime();
        QDateTime dataRight = sourceModel()->data(sourceRight, ContentsModel::LastModifiedRole).toDateTime();

        return dataLeft < dataRight;
    }

    QString dataLeft = sourceModel()->data(sourceLeft).toString();
    QString dataRight = sourceModel()->data(sourceRight).toString();

    return QString::compare(dataLeft, dataRight, Qt::CaseInsensitive) < 0;
}
