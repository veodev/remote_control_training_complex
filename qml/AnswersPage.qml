import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

Page {
    id: page
    property int answerToQuestion: 0
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

        Text {
            id: titleText
            x: 48
            width: 501
            height: 29
            text: qsTr("Выберите вариант ответа на вопрос.")
            anchors.top: parent.top
            anchors.topMargin: 40
            wrapMode: Text.WordWrap
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 24
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    Rectangle {
        id: firstButtonRectangle
        width: 100
        height: 100
        color: "#636363"
        anchors.top: parent.top
        anchors.topMargin: 95
        anchors.rightMargin: 100
        border.color: "#000000"
        border.width: 10
        x: 63
        anchors.right: secondButtonRectangle.left
        anchors.leftMargin: 80
        Button {
            id: firstAnswerButton
            width: parent.width - 15 - parent.border.width
            height: parent.height -15 - parent.border.width
            text: "1"
            font.pointSize: 30
            font.bold: true
            checkable: true
            highlighted: false
            anchors.centerIn: parent
            contentItem: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font: firstAnswerButton.font
                text: firstAnswerButton.text
                color: firstAnswerButton.checked ? "black": "white";
            }

            background: Rectangle {
                radius: 8;
                color: firstAnswerButton.checked ? "white" : "black";
            }
            onCheckedChanged: {
                if (checked) {
                    secondAnswerButton.checked = false;
                    thirdAnswerButton.checked = false;
                    answerToQuestion = 1;
                }
            }
        }
    }

    Rectangle {
        id: secondButtonRectangle
        width: 100
        height: 100
        color: "#636363"
        anchors.verticalCenter: firstButtonRectangle.verticalCenter
        border.color: "#000000"
        border.width: 10
        y: 97
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: secondAnswerButton
            width: parent.width - 15 - parent.border.width
            height: parent.height -15 - parent.border.width
            text: "2"
            font.bold: true
            font.pointSize: 30
            checkable: true
            anchors.centerIn: parent
            contentItem: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font: secondAnswerButton.font
                text: secondAnswerButton.text
                color: secondAnswerButton.checked ? "black": "white";
            }
            background: Rectangle {
                radius: 8;
                color: secondAnswerButton.checked ? "white" : "black";
            }
            onCheckedChanged: {
                if (checked) {
                    firstAnswerButton.checked = false;
                    thirdAnswerButton.checked = false;
                    answerToQuestion = 2;
                }
            }
        }
    }

    Rectangle {
        id: thirdButtonRectangle
        width: 100
        height: 100
        color: "#636363"
        anchors.verticalCenter: secondButtonRectangle.verticalCenter
        anchors.left: secondButtonRectangle.right
        anchors.leftMargin: 100
        border.color: "#000000"
        border.width: 10
        y: 97
        Button {
            id: thirdAnswerButton
            width: parent.width - 15 - parent.border.width
            height: parent.height -15 - parent.border.width
            text: "3"
            font.bold: true
            font.pointSize: 30
            checkable: true
            anchors.centerIn: parent
            contentItem: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font: thirdAnswerButton.font
                text: thirdAnswerButton.text
                color: thirdAnswerButton.checked ? "black": "white";
            }
            background: Rectangle {
                radius: 8;
                color: thirdAnswerButton.checked ? "white": "black";
            }
            onCheckedChanged: {
                if (checked) {
                    firstAnswerButton.checked = false;
                    secondAnswerButton.checked = false;
                    answerToQuestion = 3;
                }
            }
        }
    }

    Rectangle {
        x: 152
        width: 500
        height: 80
        color: "#636363"
        anchors.top: secondButtonRectangle.bottom
        anchors.topMargin: 30
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: secondButtonRectangle.horizontalCenter
        Button {
            id: confirmationButton
            width: parent.width - 15 - parent.border.width
            height: parent.height -15 - parent.border.width
            text: "Ответить"
            font.pointSize: 30
            anchors.centerIn: parent
            contentItem: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font: confirmationButton.font
                text: confirmationButton.text
                color: confirmationButton.down ? "black": "white";
            }
            background: Rectangle {
                color: confirmationButton.down ? "white" : "black"
                radius: 8
            }
            onReleased: {
                firstAnswerButton.checked = false;
                secondAnswerButton.checked = false;
                thirdAnswerButton.checked = false;
                backend.answerToQuestion(answerToQuestion)
                answerToQuestion = 0
            }
        }
        border.color: "#000000"
        border.width: 10
    }
    onVisibleChanged: if (!visible) {
                          firstAnswerButton.checked = false;
                          secondAnswerButton.checked = false;
                          thirdAnswerButton.checked = false;
                      }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:6;anchors_y:40}D{i:7;anchors_y:97}
}
 ##^##*/
