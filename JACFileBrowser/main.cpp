#include "pch.hpp"

#include "utilities.hpp"
#include "mainviewmodel.hpp"

#include "jacffmpeglib.hpp"

int main(int argc, char *argv[])
{

    qDebug() << JACFFmpegLib().test().c_str();

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl)
    {
        if (!obj && url == objUrl)
        {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);

    QQmlContext *ctx = engine.rootContext();

    // Create instances and make available to QML
    ctx->setContextProperty("viewModel", new MainViewModel(ctx));
    ctx->setContextProperty("utilities", new Utilities(ctx));

    engine.load(url);

    return app.exec();
}
