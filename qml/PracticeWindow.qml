import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtTextToSpeech

Item {
    id: practiceWindow
    visible: true
    width: 400
    height: 400
    property var stackView
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
            anchors.margins: 20
            spacing: 10

            Label {
                id: englishWordLabel
                text: "English Word"  // This will be updated with the actual English word
                font.pixelSize: 38
                color: "white"
                font.bold: true
                Layout.alignment: Qt.AlignCenter
                background: Rectangle {
                    color: "#7f5af0"
                    radius: 10
                    border.width: 3
                    border.color: "white"
                }
                padding: 15
            }

            Label {
                id: hebrewTranslationLabel
                text: "תרגום לעברית"
                font.pixelSize: 38
                color: "white"
                font.bold: true
                Layout.alignment: Qt.AlignCenter
                background: Rectangle {
                    color: "#7f5af0"
                    radius: 10
                    border.width: 3
                    border.color: "white"
                }
                padding: 15
            }

            GridLayout {
                columns: 2
                Layout.alignment: Qt.AlignCenter
                columnSpacing: 10
                rowSpacing: 10

                Button {
                    text: "Prev"
                    onClicked: prevWord()
                    background: Rectangle {
                        color: "#4A90E2"
                        radius: 10
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 60
                }

                Button {
                    text: "Next"
                    onClicked: nextWord()
                    background: Rectangle {
                        color: "#4A90E2"
                        radius: 10
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 60
                }
            }

            GridLayout {
                columns: 2
                Layout.alignment: Qt.AlignCenter
                columnSpacing: 10
                rowSpacing: 10

                Button {
                    text: "Back"
                    onClicked: stackView.pop()
                    background: Rectangle {
                        color: "#4A90E2"
                        radius: 10
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 60
                }

                Button {
                    text: "🔊 Play Sound"
                    onClicked: playSound()
                    background: Rectangle {
                        color: "#4A90E2"
                        radius: 10
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 60
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

    Keys.onBackPressed: {
                        stackView.pop();
                      }
       Component.onCompleted: {
           loadWords(level);
       }

       onLevelChanged: {
           loadWords(level);
       }
   }
