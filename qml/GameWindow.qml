import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtTextToSpeech

ApplicationWindow {
    id: gameWindow
    visible: true
    width: 400
    height: 500
    title: "Translation Game"

    property string mode: "" // "Hebrew" or "English"
    property int level: 1
    property int score: 0
    property int currentWordCount: 0
    property var dictionary: ({})
    property string currentQuestion: ""
    property string correctAnswer: ""
    property var voices: []
    property int selectedVoiceIndex: 0

    TextToSpeech {
        id: tts
        onLocaleChanged: {
            voices = availableVoices
            updateVoiceButtons()
        }
    }

    Timer {
        id: keyboardDebounceTimer
        interval: 200
        repeat: false
        onTriggered: checkKeyboardLanguage()
    }

    Rectangle {
        anchors.fill: parent
        color: "#F7F7F7"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Label {
                id: questionLabel
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: 26
                color: "white"
                padding: 15
                background: Rectangle {
                    color: "#7f5af0"
                    radius: 10
                    border.width: 3
                    border.color: "white"
                }
                Layout.preferredWidth: parent.width - 40
                Layout.preferredHeight: 60
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            TextField {
                id: answerField
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: mode === "Hebrew" ? "הקלד את התרגום..." : "Type your translation here..."
                background: Rectangle {
                    color: "#7f5af0"
                    radius: 5
                    border.width: 1
                    border.color: "white"
                }
                color: "white"
                onTextChanged: {
                    if (text.length % 3 === 0) {
                        keyboardDebounceTimer.restart()
                    }
                }
            }

            Label {
                id: feedbackLabel
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: 18
                wrapMode: Text.WordWrap
            }

            Label {
                id: scoreLabel
                text: "Score: " + score
                font.pixelSize: 22
                color: "#4A90E2"
                Layout.alignment: Qt.AlignCenter
            }

            RowLayout {
                Layout.alignment: Qt.AlignCenter
                spacing: 10

                Button {
                    text: "🔊 Play Word"
                    onClicked: playAudio()
                    Layout.preferredWidth: 120
                }

                Button {
                    text: "Check Answer"
                    onClicked: checkAnswer()
                    Layout.preferredWidth: 120
                }
            }

            Button {
                text: "Show Answer"
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: 120
                onClicked: revealAnswer()
            }

            GridLayout {
                id: voiceButtonsGrid
                Layout.alignment: Qt.AlignCenter
                columns: mode === "English" ? 3 : 1
            }

            Button {
                text: "Back"
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: 120
                onClicked: stackView.pop()
            }
        }
    }

    function loadDictionary() {
        console.log("Loading dictionary for level:", level);
        var jsonData = wordDictionaries["level" + level];
        console.log("JSON Data for level " + level + ":", jsonData);

        if (!jsonData || jsonData === "{}") {
            console.error("JSON data is empty for level", level);
            dictionary = {};
            setupQuestion();
            return;
        }

        try {
            dictionary = JSON.parse(jsonData);
            setupQuestion();
        } catch (error) {
            console.error("Failed to parse JSON:", error);
            console.error("JSON Content:", jsonData);
            dictionary = {};
            setupQuestion();
        }
    }

    function setupQuestion() {
        var keys = Object.keys(dictionary);
        if (keys.length === 0) {
            questionLabel.text = "No questions available";
            return;
        }

        currentQuestion = keys[Math.floor(Math.random() * keys.length)];
        correctAnswer = dictionary[currentQuestion];

        questionLabel.text = mode === "Hebrew" ? correctAnswer : currentQuestion;
        answerField.text = "";
        playAudio();
    }

    function checkAnswer() {
        if (answerField.text === "") {
            feedbackLabel.text = "Please enter the translation";
            feedbackLabel.color = "#7f5af0";
            return;
        }

        var userAnswer = answerField.text.toLowerCase();
        var correct = (mode === "Hebrew" ? currentQuestion : correctAnswer).toLowerCase();

        if (removeHebrewDiacritics(userAnswer) === removeHebrewDiacritics(correct)) {
            feedbackLabel.text = "Correct!";
            feedbackLabel.color = "#7f5af0";
            score++;
            scoreLabel.text = "Score: " + score;
            currentWordCount++;

            if (currentWordCount >= Object.keys(dictionary).length) {
                showLevelComplete();
            } else {
                setupQuestion();
            }
        } else {
            feedbackLabel.text = "Incorrect. Try again!";
            feedbackLabel.color = "#FF0000";
        }
        answerField.text = "";
    }

    function showLevelComplete() {
        var dialog = dialogComponent.createObject(gameWindow, {
            text: "Congratulations! You've completed Level " + level + 
                  "\nFinal Score: " + score + "/" + Object.keys(dictionary).length
        });
        dialog.accepted.connect(function() {
            stackView.pop();
        });
        dialog.open();
    }

    function removeHebrewDiacritics(text) {
        return text.replace(/[\u0591-\u05C7]/g, "");
    }

    function playAudio() {
        var wordToSpeak = mode === "Hebrew" ? correctAnswer : currentQuestion;
        if (wordToSpeak) {
            tts.say(wordToSpeak);
        }
    }

    function revealAnswer() {
        var answer = mode === "Hebrew" ? currentQuestion : correctAnswer;
        feedbackLabel.text = "The answer is: " + answer;
        feedbackLabel.color = "#7f5af0";
        answerField.text = answer;
    }

    function checkKeyboardLanguage() {
        if (answerField.text === "") return;
        
        var lastChar = answerField.text.charAt(answerField.text.length - 1);
        var isHebrew = /[\u0590-\u05FF]/.test(lastChar);
        var isWrongKeyboard = (mode === "Hebrew" && isHebrew) || 
                             (mode === "English" && !isHebrew);

        if (isWrongKeyboard) {
            feedbackLabel.text = mode === "Hebrew" ? 
                "Please switch to English keyboard" : 
                "נא החלף למקלדת עברית";
            feedbackLabel.color = "#4A90E2";
        } else {
            feedbackLabel.text = "";
        }
    }

    Component {
        id: dialogComponent
        Dialog {
            property alias text: messageLabel.text
            anchors.centerIn: parent
            modal: true
            standardButtons: Dialog.Ok
            
            Label {
                id: messageLabel
                wrapMode: Text.WordWrap
            }
        }
    }

    Component.onCompleted: {
        tts.locale = mode === "Hebrew" ? 
            Qt.locale("he_IL") : 
            Qt.locale("en_US");
        loadDictionary();
    }
}
