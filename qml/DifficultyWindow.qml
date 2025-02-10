import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 400
    height: 500
    title: "Level Selection"

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

            Repeater {
                model: 5
                delegate: Button {
                    text: "Level " + (index + 1)
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 50
                    onClicked: {
                        console.log("Level " + (index + 1) + " clicked");
                        stackView.push(practiceComponent.createObject(stackView, { level: index + 1 }));
                    }
                }
            }

            Component {
                id: practiceComponent
                PracticeWindow {
                    level: modelData.level
                    onClosing: stackView.pop()
                }
            }

            Button {
                text: "Back"
                Layout.preferredWidth: 150
                Layout.preferredHeight: 50
                onClicked:stackView.pop()
            }
        }
    }
}
