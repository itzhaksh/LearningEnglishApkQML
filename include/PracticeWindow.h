#ifndef PRACTICEWINDOW_H
#define PRACTICEWINDOW_H

#include <QObject>
#include <QDomDocument>
#include <QFile>
#include <QDebug>

class PracticeWindow : public QObject {
    Q_OBJECT
    Q_PROPERTY(int level READ level WRITE setLevel NOTIFY levelChanged)

public:
    explicit PracticeWindow(QObject *parent = nullptr) : QObject(parent), m_level(0) {}

    int level() const { return m_level; }
    void setLevel(int level) {
        if (m_level != level) {
            m_level = level;
            emit levelChanged();
            loadXMLForLevel(m_level);
        }
    }

signals:
    void levelChanged();

private:
    int m_level;

    void loadXMLForLevel(int level) {
        // בודקים את הקובץ המתאים לרמה
        QString fileName = QString(":/resources/dictionary_level%1.xml").arg(level);
        QFile file(fileName);

        if (!file.open(QIODevice::ReadOnly)) {
            qWarning() << "Error opening XML file:" << fileName;
            return;
        }

        QDomDocument doc;
        if (!doc.setContent(&file)) {
            qWarning() << "Error parsing XML file:" << fileName;
            return;
        }

        QDomElement root = doc.documentElement();
        qDebug() << "Loaded XML for Level" << level;

        // כאן ניתן להוסיף עיבוד נוסף של ה-XML אם צריך
    }
};

#endif // PRACTICEWINDOW_H
