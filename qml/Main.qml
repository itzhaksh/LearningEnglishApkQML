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
            anchors.fill: parent
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
                        onClicked: stackView.push("qrc:/qml/DifficultyWindow.qml")
                    }

                    Button {
                        text: "English Mode"
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 100
                        onClicked: stackView.push("qrc:/qml/DifficultyWindow.qml")
                    }

                    Button {
                        text: "Practice Mode"
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 100
                        onClicked: stackView.push("qrc:/qml/DifficultyWindow.qml")
                    }

                    Button {
                        text: "Memory Game"
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 100
                        onClicked: stackView.push("qrc:/qml/DifficultyWindow.qml")
                    }
                }

                Button {
                    text: "Exit"
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 60
                    onClicked: Qt.quit()
                }
            }
        }
    }
}
