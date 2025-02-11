import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    anchors.fill: parent
    color: "#F7F7F7"

    property string gameMode

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
                                   console.log("Selected mode:", gameMode);
                                   var component;
                                   var properties = { level: index + 1 };

                                   switch(gameMode) {
                                       case "Hebrew":
                                           component = "qrc:/qml/GameWindow.qml";
                                           properties.mode = "Hebrew";
                                           break;
                                       case "English":
                                           component = "qrc:/qml/GameWindow.qml";
                                           properties.mode = "English";
                                           break;
                                       case "Practice":
                                           component = "qrc:/qml/PracticeWindow.qml";
                                           break;
                                       case "MemoryGame":
                                              component = "qrc:/qml/MemoryGame.qml";
                                              break;
                                       default:
                                           console.log("Unknown mode:", gameMode);
                                           return;
                                   }

                                   var componentObj = Qt.createComponent(component);
                                   if (componentObj.status === Component.Ready) {
                                       stackView.push(componentObj.createObject(stackView, properties));
                                   } else {
                                       console.error("Error loading component:", componentObj.errorString());
                                   }
                               }
                           }
                       }


        Button {
            text: "Back"
            Layout.preferredWidth: 150
            Layout.preferredHeight: 50
            onClicked: stackView.pop()
        }
    }
}
