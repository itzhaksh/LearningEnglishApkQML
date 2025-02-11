import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtTextToSpeech

ApplicationWindow {
    id: practiceWindow
    visible: true
    width: 400
    height: 400
    title: "Practice English"

    property var wordsMap: ({})
    property var englishWords: []
    property int currentIndex: 0
    property int level: 1

    TextToSpeech {
        id: textToSpeech
    }

    Rectangle {
        anchors.fill: parent
        color: "#F7F7F7"

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10

            Label {
                id: englishWordLabel
                text: "English Word"
                font.pixelSize: 38
                color: "#7f5af0"
                font.bold: true
                Layout.alignment: Qt.AlignCenter
            }

            Label {
                id: hebrewTranslationLabel
                text: "תרגום לעברית"
                font.pixelSize: 38
                color: "#7f5af0"
                font.bold: true
                Layout.alignment: Qt.AlignCenter
            }

            RowLayout {
                spacing: 10

                Button {
                    text: "Back"
                    onClicked: stackView.pop()
                }

                Button {
                    text: "Prev"
                    onClicked: prevWord()
                }

                Button {
                    text: "Next"
                    onClicked: nextWord()
                }

                Button {
                    text: "🔊 Play Sound"
                    onClicked: playSound()
                }
            }
        }
    }

    function loadWords(level) {
        console.log("Loading words for level:", level);
        var jsonData = wordDictionaries["level" + level];
        console.log("JSON Data for level " + level + ":", jsonData);

        if (!jsonData || jsonData === "{}") {
            console.error("JSON data is empty for level", level);
            wordsMap = {};
            englishWords = [];
            updateDisplay();
            return;
        }

        try {
            wordsMap = JSON.parse(jsonData);
            englishWords = Object.keys(wordsMap);
            currentIndex = 0;
            updateDisplay();
            playSound();

        } catch (error) {
            console.error("Failed to parse JSON:", error);
            console.error("JSON Content:", jsonData);
            wordsMap = {};
            englishWords = [];
            updateDisplay();
        }
    }

    function updateDisplay() {
        if (englishWords.length === 0) {
            englishWordLabel.text = "";
            hebrewTranslationLabel.text = "";
            return;
        }

        if (currentIndex < 0 || currentIndex >= englishWords.length) {
            currentIndex = 0;
        }

        var englishWord = englishWords[currentIndex];
        var hebrewTranslation = wordsMap[englishWord];

        englishWordLabel.text = englishWord;
        hebrewTranslationLabel.text = hebrewTranslation;
    }

    function nextWord() {
        if (currentIndex < englishWords.length - 1) {
            currentIndex++;
            updateDisplay();
            playSound();
        } else {
            console.log("Already at the last word.");
        }
    }

    function prevWord() {
        if (currentIndex > 0) {
            currentIndex--;
            updateDisplay();
            playSound();
        } else {
            console.log("Already at the first word.");
        }
    }

    function playSound() {
        var wordToSpeak = englishWordLabel.text;
        if (wordToSpeak !== "") {
            textToSpeech.locale = Qt.locale("en_US");
            textToSpeech.say(wordToSpeak);
        } else {
            console.log("No word to speak.");
        }
    }

    Component.onCompleted: {
        loadWords(level);
    }

    onLevelChanged: {
        loadWords(level);
    }
}
