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
            id: element
            x: 48
            y: 40
            width: 501
            height: 29
            text: qsTr("Выберите вариант ответа на вопрос.")
            wrapMode: Text.WordWrap
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 24
        }
    }
    Rectangle {
        id: firstButtonRectangle
        width: 130
        height: 130
        color: "#636363"
        border.color: "#000000"
        border.width: 10
        x: 63
        y: 97
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
        width: 130
        height: 130
        color: "#636363"
        border.color: "#000000"
        border.width: 10
        x: 255
        y: 97

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
        width: 130
        height: 130
        color: "#636363"
        border.color: "#000000"
        border.width: 10
        x: 443
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
        y: 263
        width: 510
        height: 130
        color: "#636363"
        anchors.horizontalCenterOffset: -2
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
