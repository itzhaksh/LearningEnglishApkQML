import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtTextToSpeech

Item {
    id: gameWindow
    visible: true
    width: 400
    height: 500
    property var stackView
    property string mode: "English"
    property int level: 1
    property int score: 0
    property int currentWordCount: 0
    property var dictionary: ({})
    property string currentQuestion: ""
    property string correctAnswer: ""
    property var voices: []
    property int selectedVoiceIndex: 0

    function removeHebrewDiacritics(text) {
        return text.replace(/[\u0591-\u05C7]/g, "");
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

        // Use a Timer to delay playAudio until TTS is ready
        timer.start();
    }

    Timer {
        id: timer
        interval: 250 // Short delay
        running: false
        repeat: false
        onTriggered: {
            playAudio();
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

    Component.onCompleted: {
        loadDictionary();
    }

    function revealAnswer() {
        var answer = mode === "Hebrew" ? currentQuestion : correctAnswer;
        feedbackLabel.text = "The answer is: " + answer;
        feedbackLabel.color = "#7f5af0";
        answerField.text = answer;
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

    TextToSpeech {
        id: tts
        locale: mode === "Hebrew" ? Qt.locale("he_IL") : Qt.locale("en_US")

        onLocaleChanged: {
            console.log("Locale changed to:", locale);
            loadVoices();
        }

        Component.onCompleted: {
            loadVoices();
        }
    }

    function loadVoices() {
        voices = tts.availableVoices;
        console.log("Available voices:", voices.length, "for locale:", tts.locale);
        if (voices.length > 0) {
            console.log("Voices loaded successfully:", voices);
        } else {
            console.log("No voices available for locale:", tts.locale);
        }
    }

    function playAudio() {
        var wordToSpeak = mode === "Hebrew" ? correctAnswer : currentQuestion;
        if (wordToSpeak) {
            tts.locale = mode === "Hebrew" ? Qt.locale("he_IL") : Qt.locale("en_US");

            var selectedVoice = null;
            for (var i = 0; i < voices.length; i++) {
                if (voices[i].locale.name === tts.locale.name) {
                    selectedVoice = voices[i];
                    break;
                }
            }

            if (selectedVoice) {
                tts.voice = selectedVoice;
            } else {
                console.warn("No suitable voice found for locale:", tts.locale);
                if (voices.length > 0) {
                    tts.voice = voices[0];
                    console.warn("Falling back to default voice");
                }
            }

            console.log("Speaking:", wordToSpeak, "using locale:", tts.locale, "and voice:", tts.voice ? tts.voice.name : "default");
            tts.say(wordToSpeak);
        }
    }

    function setMode(newMode) {
        mode = newMode;
        tts.locale = mode === "Hebrew" ? Qt.locale("he_IL") : Qt.locale("en_US");
        loadDictionary();
    }

    function showLevelComplete() {
        console.log("Level Complete!");
        level++;
        currentWordCount = 0;
        loadDictionary();
    }

    Rectangle {
        anchors.fill: parent
        color: "#F7F7F7"

        ColumnLayout {
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            width: parent.width * 0.8

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

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        playAudio();
                    }
                }
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
                selectByMouse: true
                selectedTextColor: "white"
                selectionColor: "#4A90E2"
                onFocusChanged: {
                    if (focus) {
                        placeholderText = "";
                    } else {
                        placeholderText = mode === "Hebrew" ? "הקלד את התרגום..." : "Type your translation here...";
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

            Button {
                text: "Check Answer"
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: 200
                Layout.preferredHeight: 60
                onClicked: checkAnswer()
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
            }

            Button {
                id: showAnswerButton
                text: "Show Answer"
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: 200
                Layout.preferredHeight: 60
                onClicked: revealAnswer()
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
            }
        }
    }

    Keys.onBackPressed: {
        stackView.pop();
    }
}
