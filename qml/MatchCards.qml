import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: matchCards
    visible: true
    width: parent ? parent.width : 420
    height: parent ? parent.height : 420

    property var stackView
    property var wordsMap: ({})
    property var englishWords: []
    property int matchedPairs: 0
    property var firstSelectedButton: null
    property int level: 1

    Rectangle {
        anchors.fill: parent
        color: "#F7F7F7"

        ColumnLayout {
            id: mainColumn
            anchors.centerIn: parent
            anchors.margins: 20
            spacing: 15
            width: parent.width - 40

            GridLayout {
                id: cardGrid
                columns: 2
                Layout.alignment: Qt.AlignHCenter
                columnSpacing: 10
                rowSpacing: 10
                Layout.preferredWidth: 340
                Layout.preferredHeight: 260
            }

            Item {
                Layout.fillHeight: true
                Layout.minimumHeight: 80
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Button {
                    text: "Back"
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 50
                    onClicked: {
                        if (stackView) {
                            stackView.pop();
                        }
                    }
                    background: Rectangle {
                        color: parent.pressed ? "green" : parent.hovered ? "#4A90E2" : "#7f5af0"
                        radius: 10
                        border.width: parent.hovered ? 3 : 2
                        border.color: "white"
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
                    text: "Reset Game"
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 50
                    onClicked: resetGame()
                    background: Rectangle {
                        color: parent.pressed ? "green" : parent.hovered ? "#4A90E2" : "#7f5af0"
                        radius: 10
                        border.width: parent.hovered ? 3 : 2
                        border.color: "white"
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
    }

    Component {
        id: cardButton
        Button {
            property string word: ""
            property bool matched: false
            width: 160
            height: 60
            text: word
            enabled: !matched
            clip: true
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
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

            }
        }
    }

    Component {
           id: cellContainer
           Item {
               Layout.preferredWidth: 160
               Layout.preferredHeight: 60
               property var content: null
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
        console.log("Selected English words:", selectedWords);
        var hebrewWords = selectedWords.map(word => wordsMap[word]);
        console.log("Corresponding Hebrew words:", hebrewWords);
        var shuffledHebrew = shuffleArray(hebrewWords.slice());
        console.log("Shuffled Hebrew words:", shuffledHebrew);
        for (var j = 0; j < selectedWords.length; j++) {
            createCard(selectedWords[j], j, 0);
            createCard(shuffledHebrew[j], j, 1);
        }
        matchedPairs = 0;
        firstSelectedButton = null;
    }

    function createCard(word, row, col) {
        var container = cellContainer.createObject(cardGrid);
                container.Layout.row = row;
                container.Layout.column = col;
                var card = cardButton.createObject(container, { word: word });
                container.content = card;
                card.clicked.connect(function() { handleCardClick(card); });
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
            var firstContainer = firstCard.parent;
            var secondContainer = secondCard.parent;
            firstCard.destroy();
            secondCard.destroy();
            var placeholder1 = Qt.createQmlObject(`
                import QtQuick 2.15
                Item {
                    width: 160
                    height: 60
                    visible: false
                }
            `, firstContainer);
            var placeholder2 = Qt.createQmlObject(`
                import QtQuick 2.15
                Item {
                    width: 160
                    height: 60
                    visible: false
                }
            `, secondContainer);
            firstContainer.content = placeholder1;
            secondContainer.content = placeholder2;
            if (matchedPairs === 5) {
                showCongratulations();
            }
        }
    function handleMismatch(firstCard, secondCard) {
            firstCard.background.color = "red";
            secondCard.background.color = "red";
            var timer = Qt.createQmlObject(`
                import QtQuick 2.15
                Timer {
                    property var firstCard: null
                    property var secondCard: null
                    interval: 1000
                    running: true
                    repeat: false
                    onTriggered: {
                        if (firstCard) {
                            firstCard.checked = false;
                            firstCard.enabled = true;
                            firstCard.background.color = "#7f5af0";
                        }
                        if (secondCard) {
                            secondCard.checked = false;
                            secondCard.enabled = true;
                            secondCard.background.color = "#7f5af0";
                        }
                        destroy();
                    }
                }
            `, matchCards, "mismatchTimer");
            timer.firstCard = firstCard;
            timer.secondCard = secondCard;
        }
    function showCongratulations() {
        var dialog = Qt.createQmlObject(`
            import QtQuick
            import QtQuick.Controls
            import QtQuick.Layouts
            Dialog {
                title: "Congratulations!"
                modal: true
                anchors.centerIn: parent
                width: 300
                padding: 20
                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 12
                    border.width: 1
                    border.color: "#E0E0E0"
                }
                contentItem: ColumnLayout {
                    spacing: 20
                    Label {
                        text: "You matched all words! 🎉"
                        color: "#333333"
                        font.pixelSize: 18
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                    Button {
                        text: "OK"
                        Layout.alignment: Qt.AlignHCenter
                        width: 120
                        height: 40
                        onClicked: parent.parent.close()
                        background: Rectangle {
                            color: pressed ? "green" : hovered ? "#4A90E2" : "#7f5af0"
                            radius: 10
                            border.width: hovered ? 3 : 2
                            border.color: "white"
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
                onClosed: resetGame()
            }
        `, matchCards, "congratulationsDialog");
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

    Keys.onBackPressed: {
        stackView.pop();
    }
}
