#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include <QAbstractTableModel>
#include <QAbstractListModel>

class TestListModel : public QAbstractListModel
{
public:
    int rowCount(const QModelIndex &parent) const override
    {
        return 10;
    }
    QVariant data(const QModelIndex &index, int role) const override
    {
        switch (role)
        {
        case Qt::DisplayRole:
            return QString("data: %1").arg(index.row());
        default:
            return {};
        }
    }
};

class TestTableModel : public QAbstractTableModel
{
public:
    int rowCount(const QModelIndex &parent) const override
    {
        return 10;
    }
    int columnCount(const QModelIndex &parent) const override
    {
        return 10;
    }
    QVariant data(const QModelIndex &index, int role) const override
    {
        switch (role)
        {
        case Qt::DisplayRole:
            return QString("data %1,%2").arg(index.row()).arg(index.column());
        default:
            return {};
        }
    }
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override
    {
        switch (role)
        {
        case Qt::DisplayRole:
            return QString("header %1").arg(section);
        default:
            return {};
        }
    }
};

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // TODO qtquickcontrols2.conf not working, hard code here
    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/JACFileBrowser/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("testListModel", new TestListModel());
    engine.rootContext()->setContextProperty("testTableModel", new TestTableModel());


    engine.load(url);

    return app.exec();
}
