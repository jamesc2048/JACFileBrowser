#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>

#include "drivesmodel.hpp"
#include "contentsmodel.hpp"
#include "tablemodelproxy.hpp"
#include "utils.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("JACFileBrowser");
    app.setApplicationVersion(APP_VERSION);
    app.setOrganizationName("JAC");
    app.setOrganizationDomain("crisafulli.me");

    QQuickWindow::setTextRenderType(QQuickWindow::TextRenderType::NativeTextRendering);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    auto rc = engine.rootContext();

    // TODO this should be one per tab
    ContentsModel* contentsModel = new ContentsModel();

    rc->setContextProperty("contentsModel", contentsModel);
    rc->setContextProperty("tableModelProxy", new TableModelProxy(contentsModel));
    rc->setContextProperty("drivesModel", new DrivesModel());
    rc->setContextProperty("utils", new Utils());

    engine.load(url);

    return app.exec();
}
