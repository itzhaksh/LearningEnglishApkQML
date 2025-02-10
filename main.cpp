#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

QString loadJsonFile(const QString &filePath) {
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to open file:" << filePath;
        return "{}";
    }
    QByteArray jsonData = file.readAll();
    file.close();
    return QString::fromUtf8(jsonData);
}

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QVariantMap dictionaries;
    for (int i = 1; i <= 5; i++) {
        QString filePath = QString(":/dictionary_level%1.json").arg(i);
        QString jsonData = loadJsonFile(filePath);
        dictionaries.insert(QString("level%1").arg(i), jsonData);
    }

    engine.rootContext()->setContextProperty("wordDictionaries", dictionaries);

    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
