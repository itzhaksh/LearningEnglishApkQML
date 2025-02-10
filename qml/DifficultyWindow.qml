import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 400
    height: 500
    title: "Level Selection"

    function loadDictionary(level) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "qrc:/dictionary_level" + level + ".json", true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var dictionary = JSON.parse(xhr.responseText);
                    mainWindow.openLevel(level, dictionary);
                } else {
                    console.error("Failed to load dictionary for level", level);
                }
            }
        }
        xhr.send();
    }

    Rectangle {
        anchors.fill: parent
        color: "#F7F7F7"

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10

            Label {
                text: "Select Level"
                font.pixelSize: 24
                color: "#4A90E2"
                font.bold: true
                Layout.alignment: Qt.AlignCenter
            }

            Button {
                text: "Level 1"
                Layout.preferredWidth: 150
                Layout.preferredHeight: 50
                onClicked: {
                    loadDictionary(1)
                }
            }

            Button {
                text: "Level 2"
                Layout.preferredWidth: 150
                Layout.preferredHeight: 50
                onClicked: {
                    loadDictionary(2)
                }
            }

            Button {
                text: "Level 3"
                Layout.preferredWidth: 150
                Layout.preferredHeight: 50
                onClicked: {
                    loadDictionary(3)
                }
            }

            Button {
                text: "Level 4"
                Layout.preferredWidth: 150
                Layout.preferredHeight: 50
                onClicked: {
                    loadDictionary(4)
                }
            }

            Button {
                text: "Level 5"
                Layout.preferredWidth: 150
                Layout.preferredHeight: 50
                onClicked: {
                    loadDictionary(5)
                }
            }

            Button {
                text: "Back"
                Layout.preferredWidth: 150
                Layout.preferredHeight: 50
                onClicked: {
                    stackView.pop()
                }
            }
        }
    }
}
