#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQuickStyle>
#include <QDateTime>

static void loggingHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    // TODO file here for logging

    //const QString message = qFormatLogMessage(type, context, msg);

#ifdef Q_OS_WIN
#define SEPARATOR_CHAR '\\'
#else
#define SEPARATOR_CHAR '/'
#endif

    const char *file = strrchr(context.file ? context.file : "", SEPARATOR_CHAR);
    file = file ? file + 1 : "(no file)";

    const int line = context.line;
    //const char *function = context.function ? context.function : "(no function)";
    //const char *category = context.category ? context.category : "(no category)";

    QString currentDt = QDateTime::currentDateTime().toString(Qt::DateFormat::ISODateWithMs);

    const char* msgTypeNames[] = { "Debug", "Warning", "Critical", "Fatal", "Info" };
    const char* msgTypeName = msgTypeNames[(uint32_t)type];

    printf("%s - %s %s:%d - %s\n",
           currentDt.toLocal8Bit().constData(),
           msgTypeName,
           file,
           line,
           //function,
           //category,
           msg.toLocal8Bit().constData());
    fflush(stdout);
}

int main(int argc, char *argv[])
{
    //qSetMessagePattern("[%{time process}] %{threadid} file:/%{file}:%{line}: %{message}");
    qInstallMessageHandler(loggingHandler);

    QGuiApplication app(argc, argv);

    app.setApplicationName("JACFileBrowser");
    app.setApplicationVersion(APP_VERSION);
    app.setOrganizationName("JAC");
    app.setOrganizationDomain("crisafulli.me");

    QQuickWindow::setTextRenderType(QQuickWindow::TextRenderType::NativeTextRendering);
    //QQuickStyle::setStyle("Basic");

    qInfo() << "Launching JACFileBrowser version " APP_VERSION;

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("JACFileBrowser", "Main");

    return app.exec();
}
