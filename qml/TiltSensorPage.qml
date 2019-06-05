import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

Page {
    id: page

    Rectangle {
        id: rcRectangle
        color: "#ffffff"
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
        x: 51
        width: 242
        height: 160
        anchors.verticalCenterOffset: 16
        anchors.horizontalCenterOffset: -148
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: backButtonRectangle.bottom
        anchors.topMargin: 31
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.fillHeight: false
        Layout.fillWidth: true

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
        id: backButtonRectangle
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

    Rectangle {
        id: debugButtonRectangle
        x: 344
        y: 45
        width: 138
        height: 70
        color: "#636363"
        anchors.right: parent.right
        anchors.rightMargin: 60
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: backButtonRectangle.verticalCenter
        border.width: 10
        border.color: "#000000"
        Button {
            id: debugButton
            width: parent.width - 15 - parent.border.width
            height: parent.height - 15 - parent.border.width
            checkable: true
            background: Rectangle {
                color: debugButton.checked ? "white" : "black"
                radius: 8
            }
            contentItem: Text {
                color: debugButton.checked ? "black": "white"
                text: "Отладка"
                font: debugButton.font
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            anchors.centerIn: parent
            font.pointSize: 20
            onCheckedChanged: {
                stopButtonRectangle.visible = debugButton.checked;
                plusButtonRectangle.visible = debugButton.checked;
                minusButtonRectangle.visible = debugButton.checked;
                if (!debugButton.checked && stopButton.checked) {
                    stopButton.checked = false;
                }
                backend.setDebugMode(debugButton.checked);
            }
        }
    }

    Rectangle {
        id: minusButtonRectangle
        x: 301
        width: 132
        height: 70
        color: "#636363"
        anchors.top: stopButtonRectangle.bottom
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 207
        border.width: 10
        border.color: "#000000"
        visible: false
        Button {
            id: minusButton
            width: parent.width - 15 - parent.border.width
            height: parent.height - 15 - parent.border.width
            background: Rectangle {
                color: minusButton.down ? "white" : "black"
                radius: 8
            }
            contentItem: Text {
                color: minusButton.down ? "black": "white"
                text: "-0,5°"
                font: minusButton.font
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            anchors.centerIn: parent
            font.pointSize: 20
            onReleased: backend.changeAngle(-0.5);
        }
    }

    Rectangle {
        id: plusButtonRectangle
        x: 452
        width: 138
        height: 70
        color: "#636363"
        anchors.top: stopButtonRectangle.bottom
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 60
        border.width: 10
        border.color: "#000000"
        visible: false
        Button {
            id: plusButton
            width: parent.width - 15 - parent.border.width
            height: parent.height - 15 - parent.border.width
            background: Rectangle {
                color: plusButton.down ? "white" : "black"
                radius: 8
            }
            contentItem: Text {
                color: plusButton.down ? "black": "white"
                text: "+0,5°"
                font: plusButton.font
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            anchors.centerIn: parent
            font.pointSize: 20
            onReleased: backend.changeAngle(0.5);
        }
    }

    Rectangle {
        id: stopButtonRectangle
        x: 301
        y: 163
        width: 279
        height: 70
        color: "#636363"
        anchors.right: parent.right
        anchors.rightMargin: 60
        border.width: 10
        border.color: "#000000"
        visible: false
        Button {
            id: stopButton
            width: parent.width - 15 - parent.border.width
            height: parent.height - 15 - parent.border.width
            checkable: true
            background: Rectangle {
                color: stopButton.checked ? "white" : "black"
                radius: 8
            }
            contentItem: Text {
                color: stopButton.checked ? "black": "white"
                text: "СТОП"
                font: stopButton.font
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            anchors.centerIn: parent
            font.pointSize: 20
            onCheckedChanged: backend.changeMotionMode(!stopButton.checked)
        }
    }

}
