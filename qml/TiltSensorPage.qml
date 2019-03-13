import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

Page {
    id: page

    Rectangle {
        id: rcRectangle
        anchors.fill: parent
        visible: true
        border.color: "black"
        border.width: 30
        radius: 10
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        gradient: Gradient {
            GradientStop {position: 0; color: "#ffffff";}
            GradientStop {position: 0.5; color: "#ababab"}
            GradientStop {position: 1; color: "#ffffff";}
        }

        ColumnLayout {
            id: columnLayout
            x: 286
            y: 173
            width: 100
            height: 100
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: forwardText
                width: 40
                color: "#000000"
                text: qsTr("▲")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.pixelSize: 50
            }

            Text {
                id: xRotationText
                width: 110
                height: 58
                text: qsTr("0")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillHeight: false
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 30
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        backend.calibrateTiltSensor()
                    }
                }
            }

            Text {
                id: backwardText
                text: qsTr("▼")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.pixelSize: 50
            }
        }
    }

    Rectangle {
        x: 51
        y: 45
        width: 100
        height: 70
        color: "#636363"
        border.color: "#000000"
        Button {
            id: backButton
            width: parent.width - 15 - parent.border.width
            height: parent.height - 15 - parent.border.width
            anchors.centerIn: parent
            font.pointSize: 20
            contentItem: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font: backButton.font
                color: backButton.down ? "black": "white";
                text: "Назад"
            }
            background: Rectangle {
                color: backButton.down ? "white" : "black"
                radius: 8
            }
            onReleased: stackView.pop()
        }
        border.width: 10
    }

    Connections {
        target: backend
        onDoTiltXRotationChanged: {
            if (value < 0) {
                forwardText.color = "transparent"
                backwardText.color = "black"
            }
            else if (value > 0) {
                forwardText.color = "black"
                backwardText.color = "transparent"
            }
            else {
                forwardText.color = "black"
                backwardText.color = "black"
            }
            xRotationText.text = Number(value).toFixed(1) + "°";
        }
    }
}
