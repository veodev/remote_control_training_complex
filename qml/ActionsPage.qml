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

    Rectangle {
        id: putFlagButtonRectangle
        x: 54
        width: 510
        height: 81
        color: "#636363"
        anchors.top: putSwitchLockerButtonRectangle.bottom
        anchors.topMargin: 13
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: rcRectangle.horizontalCenter
        border.color: "#000000"
        border.width: 10
        Button {
            id: putFlagButton
            width: parent.width - 15 - parent.border.width
            height: parent.height -15 - parent.border.width
            font.pointSize: 30
            anchors.centerIn: parent
            contentItem: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font: putFlagButton.font
                color: putFlagButton.down ? "black": "white";
                text: "Установить флажок"
            }
            background: Rectangle {
                color: putFlagButton.down ? "white" : "black"
                radius: 8
            }
            onReleased: {
                backend.action(1)
                stackView.pop()
            }
        }
    }

    Rectangle {
        id: putSwitchLockerButtonRectangle
        x: 54
        width: 510
        height: 80
        color: "#636363"
        anchors.top: backButtonRectangle.bottom
        anchors.topMargin: 13
        anchors.horizontalCenterOffset: 0
        border.width: 10
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: "#000000"
        Button {
            id: putSwitchLockerButton
            width: parent.width - 15 - parent.border.width
            height: parent.height -15 - parent.border.width
            anchors.centerIn: parent
            font.pointSize: 30
            background: Rectangle {
                color: putSwitchLockerButton.down ? "white" : "black"
                radius: 8
            }
            contentItem: Text {
                color: putSwitchLockerButton.down ? "black": "white"
                text: "Установить блокиратор"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font: putSwitchLockerButton.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onReleased: {
                backend.action(2)
                stackView.pop()
            }
        }
    }

    Rectangle {
        id: backButtonRectangle
        x: 51
        y: 51
        width: 100
        height: 70
        color: "#636363"
        border.color: "#000000"
        border.width: 10
        Button {
            id: backButton
            width: parent.width - 15 - parent.border.width
            height: parent.height -15 - parent.border.width
            anchors.centerIn: parent
            contentItem: Text {
                color: backButton.down ? "black": "white"
                text: "Назад"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font: backButton.font
            }
            background: Rectangle {
                color: backButton.down ? "white" : "black"
                radius: 8
            }
            font.pointSize: 20
            onReleased: stackView.pop()
        }
    }
}



/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:6;anchors_y:226}D{i:10;anchors_y:134}
}
 ##^##*/
