import QtQuick 2.11
import QtQuick.Window 2.11

import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2


ApplicationWindow {
    MainPage {id: mainPage; visible: false;}
    AnswersPage {id: answersPage; visible: false;}
    ActionsPage {id: actionsPage; visible: false;}
    SettingsPage {id: settingsPage; visible: false;}
    TiltSensorPage {id: tiltSensorPage; visible: false;}
    LoadingPage {id: loadingPage; visible: false;}

    id: window
    visible: true
    visibility: "FullScreen"
    width: 800
    height: 480

    StackView {
        id: stackView;
        anchors.fill: parent
        initialItem: loadingPage
    }

    Row {
        id: row2
        width: 261
        height: 14
        anchors.left: parent.left
        anchors.leftMargin: 40
        spacing: 0
        anchors.top: parent.top
        anchors.topMargin: 20

        Row {
            id: column
            width: 57
            height: 22
            spacing: 5

            Text {
                id: element1
                width: 22
                height: 12
                color: "#ffffff"
                text: "CDU:"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12
            }

            Rectangle {
                id: cduConnectionRectangle
                width: 10
                height: 10
                color: "#db3000"
                radius: 1
            }

        }

        Row {
            id: column1
            width: 156
            height: 28
            spacing: 5
            Text {
                id: element2
                width: 22
                height: 12
                color: "#ffffff"
                text: "TPC:"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
                id: tpcConnectionRectangle
                width: 10
                height: 10
                color: "#db3000"
                radius: 1
            }
        }
    }
    Connections {
        target: backend
        onDoMainMode: {
            stackView.pop();
            stackView.push(mainPage);
        }
        onDoAnswerMode: {
            stackView.pop();
            stackView.push(answersPage);
        }
        onDoCduConnected: {
            cduConnectionRectangle.color = "green"
        }

        onDoCduDisconnected: {
            cduConnectionRectangle.color = "red"
        }
        onDoTrainingPcConnected: {
            tpcConnectionRectangle.color = "green"
            stackView.pop()
            stackView.push(mainPage)
        }

        onDoTrainingPcDisconnected: {
            tpcConnectionRectangle.color = "red"
            if (settingsPage.visible === false) {
                stackView.pop()
                stackView.push(loadingPage)
            }
        }
    }
    onClosing: {
        close.accepted = false
    }
}
