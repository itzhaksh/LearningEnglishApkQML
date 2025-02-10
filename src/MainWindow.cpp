#include "MainWindow.h"
#include <QDebug>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

MainWindow::MainWindow(QObject *parent) : QObject(parent) {}

void MainWindow::openHebrewMode() {
    qDebug() << "Opening Hebrew Mode...";
}

void MainWindow::openEnglishMode() {
    qDebug() << "Opening English Mode...";
}

void MainWindow::openPracticeWindow() {
    qDebug() << "Opening Practice Mode...";
}

void MainWindow::openMemoryGame() {
    qDebug() << "Opening Memory Game...";
}

void MainWindow::openLevel(int level, const QVariantMap& dictionary) {
    m_currentDictionary = dictionary;
    qDebug() << "Opening level" << level << "with dictionary size:" << dictionary.size();

    QMapIterator<QString, QVariant> i(dictionary);
    while (i.hasNext()) {
        i.next();
        qDebug() << "Word:" << i.key() << "Translation:" << i.value().toString();
    }
}

void MainWindow::loadDictionaryFromFile(const QString& filePath) {
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open file:" << filePath;
        return;
    }

    QByteArray data = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (doc.isNull()) {
        qWarning() << "Failed to parse JSON from file:" << filePath;
        return;
    }

    QJsonObject jsonObject = doc.object();
    QVariantMap dictionary;

    for (auto key : jsonObject.keys()) {
        dictionary[key] = jsonObject[key].toString();
    }

    openLevel(1, dictionary);  // לאחר שטענו את הדאטה, נוכל להפעיל את הפונקציה openLevel
}
