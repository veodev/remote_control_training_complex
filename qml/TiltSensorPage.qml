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

    }

    ColumnLayout {
        id: columnLayout
        x: 302
        y: 136
        width: 550
        height: 244
        anchors.horizontalCenter: parent.horizontalCenter
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.fillHeight: false
        Layout.fillWidth: true
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: forwardText
            width: 40
            color: "#000000"
            text: qsTr("▲")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pixelSize: 50
        }

        RowLayout {
            id: rowLayout
            width: 203
            height: 100
            spacing: 20

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
                id: speedText
                width: 110
                height: 58
                text: qsTr("0")
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillHeight: false
                Layout.fillWidth: true
            }

        }

        Text {
            id: backwardText
            text: qsTr("▼")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pixelSize: 50
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
            if (angle < 0) {
                forwardText.color = "transparent"
                backwardText.color = "black"
            }
            else if (angle > 0) {
                forwardText.color = "black"
                backwardText.color = "transparent"
            }
            else {
                forwardText.color = "black"
                backwardText.color = "black"
            }
            xRotationText.text = Number(angle).toFixed(1) + "°";
            speedText.text = Number(speed).toFixed(1) + " мм/с"

        }
    }

}
