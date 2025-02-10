#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QObject>
#include <QVariantMap>

class MainWindow : public QObject {
    Q_OBJECT

public:
    explicit MainWindow(QObject *parent = nullptr);

public slots:
    void openHebrewMode();
    void openEnglishMode();
    void openPracticeWindow();
    void openMemoryGame();
    void openLevel(int level, const QVariantMap& dictionary);  // פונקציה חדשה
    void loadDictionaryFromFile(const QString& filePath);  // פונקציה חדשה

private:
    QVariantMap m_currentDictionary;
};

#endif // MAINWINDOW_H
