import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

Page {        
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

        BusyIndicator {
            id: busyIndicator
            x: 280
            y: 195
            width: 200
            height: 200
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: parent
                onPressAndHold: {
                    stackView.pop();
                    stackView.push(settingsPage)
                }
            }
        }
    }
}
