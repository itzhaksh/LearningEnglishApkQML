#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "MainWindow.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    MainWindow mainWindow;
    engine.rootContext()->setContextProperty("mainWindow", &mainWindow);

    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
