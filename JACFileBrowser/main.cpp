#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQuickStyle>

#define APP_VERSION "0.1"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("JACFileBrowser");
    app.setApplicationVersion(APP_VERSION);
    app.setOrganizationName("JAC");
    app.setOrganizationDomain("crisafulli.me");

    QQuickWindow::setTextRenderType(QQuickWindow::TextRenderType::NativeTextRendering);
    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("JACFileBrowser", "Main");

    return app.exec();
}
