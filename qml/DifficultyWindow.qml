import QtQuick
import QtQuick.Controls
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    width: parent ? parent.width : 420
    height: parent ? parent.height : 420
    color: "#F7F7F7"
    property string gameMode
    property var stackView

    Keys.onBackPressed: {
        if (stackView.depth > 1) {
            stackView.pop();
        } else {
            Qt.quit();
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Label {
            text: "Select Level"
            font.pixelSize: 32
            color: "#7f5af0"
            font.bold: true
            Layout.alignment: Qt.AlignCenter
        }

        Repeater {
            model: 5
            delegate: Button {
                text: "Level " + (index + 1)
                Layout.preferredWidth: 200
                Layout.preferredHeight: 60
                Layout.alignment: Qt.AlignHCenter

                background: Rectangle {
                    color: parent.pressed ? "green" : parent.hovered ? "#4A90E2" : "#7f5af0"
                    radius: 12  // עיגול פינות מוגדל
                    border.width: parent.hovered ? 3 : 2
                    border.color: "white"
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    console.log("Selected mode:", gameMode);
                    var component;
                    var properties = { level: index + 1, stackView: stackView, mode: gameMode };
                    switch(gameMode) {
                        case "Hebrew":
                        case "English":
                            component = gameWindowComponent;
                            break;
                        case "Practice":
                            component = practiceWindowComponent;
                            break;
                        case "Match Cards":
                            component = matchcardsComponent;
                            break;
                        default:
                            console.log("Unknown mode:", gameMode);
                            return;
                    }
                    stackView.push(component, properties);
                }
            }
        }

        Button {
            text: "Back"
            Layout.preferredWidth: 200
            Layout.preferredHeight: 60
            Layout.alignment: Qt.AlignHCenter

            background: Rectangle {
                color: parent.pressed ? "green" : parent.hovered ? "#4A90E2" : "#7f5af0"
                radius: 12
                border.width: parent.hovered ? 3 : 2
                border.color: "white"
            }

            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                stackView.pop();
            }
        }
    }
}
