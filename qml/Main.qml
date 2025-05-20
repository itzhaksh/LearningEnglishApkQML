import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 420
    height: 420
    title: "Learn English"

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: mainMenu
    }

    Component {
        id: mainMenu
        Rectangle {
            width: parent ? parent.width : 420
            height: parent ? parent.height : 420
            color: "#F7F7F7"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 10

                Image {
                    source: "qrc:/learn_english_background.png"
                    width: 150
                    height: 150
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    text: "Learn English"
                    font.pixelSize: 34
                    color: "#4A90E2"
                    Layout.alignment: Qt.AlignCenter
                }

                GridLayout {
                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 10

                    Button {
                        text: "Hebrew Mode"
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 100
                        onClicked: {
                            console.log("Selected Hebrew Mode");
                            stackView.push(difficultyWindowComponent, { gameMode: "Hebrew", stackView: stackView }); // Pass stackView
                        }
                    }

                    Button {
                        text: "English Mode"
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 100
                        onClicked: {
                            console.log("Selected English Mode");
                            stackView.push(difficultyWindowComponent, { gameMode: "English", stackView: stackView }); // Pass stackView
                        }
                    }

                    Button {
                        text: "Practice Mode"
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 100
                        onClicked: {
                            console.log("Selected Practice Mode");
                            stackView.push(difficultyWindowComponent, { gameMode: "Practice", stackView: stackView }); // Pass stackView
                        }
                    }

                    Button {
                        text: "Match Cards"
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 100
                        onClicked: {
                            console.log("Selected Match Cards Mode");
                            stackView.push(difficultyWindowComponent, { gameMode: "Match Cards", stackView: stackView }); // Pass stackView
                        }
                    }
                }

                Button {
                    text: "Exit"
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 90
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: Qt.quit()
                }
            }
        }
    }

    Component {
        id: gameWindowComponent
        GameWindow {
            anchors.fill: parent
        }
    }

    Component {
        id: matchcardsComponent
        MatchCards {
            anchors.fill: parent
        }
    }

    Component {
        id: practiceWindowComponent
        PracticeWindow {
            anchors.fill: parent
        }
    }
    Component {
        id: difficultyWindowComponent
        DifficultyWindow {
            anchors.fill: parent
        }
    }
          }

