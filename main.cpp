#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QXmlStreamReader>
#include <QDebug>
#include "PracticeWindow.h"


QVariantMap loadXmlFile(const QString &filePath) {
    QFile file(filePath);
    QVariantMap wordMap;

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to open file:" << filePath;
        return wordMap;
    }

    QXmlStreamReader xmlReader(&file);
    QString currentWord;
    QString currentTranslation;

    while (!xmlReader.atEnd()) {
        xmlReader.readNext();
        if (xmlReader.isStartElement()) {
            if (xmlReader.name() == "word") {
                currentWord = xmlReader.readElementText();
            } else if (xmlReader.name() == "translation") {
                currentTranslation = xmlReader.readElementText();
                if (!currentWord.isEmpty()) {
                    wordMap.insert(currentWord, currentTranslation);
                }
            }
        }
    }

    if (xmlReader.hasError()) {
        qWarning() << "Error reading XML file:" << xmlReader.errorString();
    }

    file.close();
    return wordMap;
}

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<PracticeWindow>("com.example", 1, 0, "PracticeWindow");

    QVariantMap dictionaries;

    for (int i = 1; i <= 5; i++) {
        QString filePath = QString(":/dictionary_level%1.xml").arg(i);
        qDebug() << "Loading file: " << filePath;
        QVariantMap wordsMap = loadXmlFile(filePath);
        dictionaries.insert(QString("level%1").arg(i), wordsMap);
        qDebug() << "Dictionaries loaded: " << dictionaries;

    }

    engine.rootContext()->setContextProperty("wordDictionaries", dictionaries);

    qDebug() << "Engine is loading QML file...";
    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    qDebug() << "Application started successfully.";
    return app.exec();
}
