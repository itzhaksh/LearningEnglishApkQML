import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: memoryGame
    visible: true
    width: 600
    height: 600
    title: "Memory Game"
    
    property var wordsMap: ({})
    property var englishWords: []
    property int matchedPairs: 0
    property var firstSelectedButton: null
    property int level: 1
    
    Rectangle {
        anchors.fill: parent
        color: "#F7F7F7"
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15
            
            GridLayout {
                id: cardGrid
                columns: 2
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter
                columnSpacing: 10
                rowSpacing: 10
            }
            
            RowLayout {
                Layout.alignment: Qt.AlignCenter
                spacing: 10
                
                Button {
                    text: "Back"
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 50
                    onClicked: {
                        stackView.pop()
                    }
                    
                    background: Rectangle {
                        color: parent.pressed ? "green" : parent.hovered ? "#4A90E2" : "#7f5af0"
                        radius: 5
                        border.width: parent.hovered ? 3 : 2
                        border.color: "white"
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                
                Button {
                    text: "Reset Game"
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 50
                    onClicked: resetGame()
                    
                    background: Rectangle {
                        color: parent.pressed ? "green" : parent.hovered ? "#4A90E2" : "#7f5af0"
                        radius: 5
                        border.width: parent.hovered ? 3 : 2
                        border.color: "white"
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
    
    Component {
        id: cardButton
        
        Button {
            property string word: ""
            property bool matched: false
            
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            text: word
            enabled: !matched
            
            background: Rectangle {
                color: parent.pressed || parent.checked ? "#4A90E2" : 
                       parent.matched ? "transparent" : "#7f5af0"
                radius: 5
                border.width: parent.hovered ? 3 : 2
                border.color: "white"
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    
    function loadWords() {
        console.log("Loading words for level:", level);
        var jsonData = wordDictionaries["level" + level];
        console.log("JSON Data for level " + level + ":", jsonData);
        
        if (!jsonData || jsonData === "{}") {
            console.error("JSON data is empty for level", level);
            wordsMap = {};
            englishWords = [];
            return;
        }
        
        try {
            wordsMap = JSON.parse(jsonData);
            englishWords = Object.keys(wordsMap);
            setupGameBoard();
        } catch (error) {
            console.error("Failed to parse JSON:", error);
            console.error("JSON Content:", jsonData);
            wordsMap = {};
            englishWords = [];
        }
    }
    
    function setupGameBoard() {
        for (var i = cardGrid.children.length - 1; i >= 0; i--) {
            cardGrid.children[i].destroy();
        }
        
        var shuffledEnglish = shuffleArray(englishWords.slice());
        var selectedWords = shuffledEnglish.slice(0, 5);
        
        var hebrewWords = selectedWords.map(word => wordsMap[word]);
        var shuffledHebrew = shuffleArray(hebrewWords);
        
        for (var j = 0; j < selectedWords.length; j++) {
            createCard(selectedWords[j], j, 0);
            createCard(shuffledHebrew[j], j, 1);
        }
        
        matchedPairs = 0;
        firstSelectedButton = null;
    }
    
    function createCard(word, row, col) {
        var card = cardButton.createObject(cardGrid, {
            word: word
        });

        card.Layout.row = row;
        card.Layout.column = col;

        card.clicked.connect(function() {
            handleCardClick(card);
        });
    }

    function handleCardClick(clickedCard) {
        if (!firstSelectedButton) {
            firstSelectedButton = clickedCard;
            firstSelectedButton.checked = true;
            return;
        }
        
        clickedCard.checked = true;
        clickedCard.enabled = false;
        
        var isMatch = (wordsMap[firstSelectedButton.word] === clickedCard.word) || 
                     (wordsMap[clickedCard.word] === firstSelectedButton.word);
        
        if (isMatch) {
            handleMatch(firstSelectedButton, clickedCard);
        } else {
            handleMismatch(firstSelectedButton, clickedCard);
        }
        
        firstSelectedButton = null;
    }
    
    function handleMatch(firstCard, secondCard) {
        firstCard.matched = true;
        secondCard.matched = true;
        matchedPairs++;
        
        firstCard.destroy();
        secondCard.destroy();

        if (matchedPairs === 5) {
            showCongratulations();
        }
    }


    function handleMismatch(firstCard, secondCard) {
        firstCard.background.color = "red";
        secondCard.background.color = "red";

        var timer = Qt.createQmlObject('import QtQuick; Timer { interval: 300; running: true; repeat: false }', parent);
        timer.triggered.connect(function() {
            firstCard.checked = false;
            secondCard.checked = false;
            firstCard.enabled = true;
            secondCard.enabled = true;
            firstCard.background.color = "#7f5af0";
            secondCard.background.color = "#7f5af0";
        });
    }
    
    function showCongratulations() {
        var dialog = Qt.createQmlObject('
              import QtQuick.Controls
              Dialog {
                title: "Congratulations"
                standardButtons: Dialog.Ok
                modal: true
                anchors.centerIn: parent
                
                Label {
                    text: "You matched all words!"
                }
                
                onAccepted: {
                    close();
                    resetGame();
                }
            }
        ', memoryGame, "congratulationsDialog");
        
        dialog.open();
    }

    function shuffleArray(array) {
        for (var i = array.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var temp = array[i];
            array[i] = array[j];
            array[j] = temp;
        }
        return array;
    }
    
    function resetGame() {
        matchedPairs = 0;
        firstSelectedButton = null;
        loadWords();
    }
    
    Component.onCompleted: {
        loadWords();
    }
}
