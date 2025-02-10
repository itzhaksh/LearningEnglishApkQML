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
        console.log("Selected level: " + level);
        if (!wordDictionaries) {
            console.error("wordDictionaries is not set!");
            return;
        }

        var wordsMapData = wordDictionaries["level" + level];

        if (!wordsMapData || Object.keys(wordsMapData).length === 0) {
            console.error("XML data is empty or undefined for level", level);
            return;
        }

        console.log("Words data loaded successfully for level:", level);
        wordsMap = wordsMapData;
        englishWords = Object.keys(wordsMap);
        currentIndex = 0;
        updateDisplay();
        playSound();

    }



    function updateDisplay() {
         if (englishWords.length === 0 || currentIndex < 0 || currentIndex >= englishWords.length)
             return;

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
     property int level : 1;

    Component.onCompleted: {
        console.log("Level changed to:", level);
         loadWords(level);
    }

}
