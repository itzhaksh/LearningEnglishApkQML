// MainWindow.cpp
#include "MainWindow.h"
#include <QDebug>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>

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

    // כאן תוכל להוסיף את הלוגיקה לטיפול במילון
    // לדוגמה, הדפסת המילים מהמילון:
    QMapIterator<QString, QVariant> i(dictionary);
    while (i.hasNext()) {
        i.next();
        qDebug() << "Word:" << i.key() << "Translation:" << i.value().toString();
    }
}
