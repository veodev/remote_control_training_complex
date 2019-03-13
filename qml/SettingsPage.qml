import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

Page {
    id: page

    RegExpValidator {
        id: ipAddressRegExp
        regExp: /^((?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){0,3}(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$/
    }
    RegExpValidator {
        id: portRegExp
        regExp: /^(([0-9]{1,4})|([1-5][0-9]{4})|(6[0-4][0-9]{3})|(65[0-4][0-9]{2})|(655[0-2][0-9])|(6553[0-5]))$/
    }
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

        RowLayout {
            id: ipLayout
            anchors.top: parent.top
            anchors.topMargin: 148
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.margins: 10

            Label {
                color: "#000000"
                text: "IP-адрес CDU:"
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.fillWidth: false
                verticalAlignment: Text.AlignVCenter
                Layout.fillHeight: true
                font.pointSize: 20
            }

            TextField {
                id: cduIpAddressText
                Layout.fillHeight: true
                horizontalAlignment: Text.AlignLeft
                validator: ipAddressRegExp
                text: backend._cduIpAddress
                Layout.minimumWidth: 300
                topPadding: 10
                font.bold: true
                Layout.fillWidth: true
                onEditingFinished: backend._cduIpAddress = cduIpAddressText.text
            }

            Label {
                color: "#000000"
                text: ":"
                font.pointSize: 20
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                horizontalAlignment: Text.AlignRight
                Layout.fillHeight: true
                Layout.fillWidth: false
                verticalAlignment: Text.AlignVCenter
            }

            TextField {
                id: cduPortText
                width: 100
                text: backend._cduPort
                Layout.maximumWidth: 100
                font.bold: true
                topPadding: 10
                horizontalAlignment: Text.AlignLeft
                Layout.fillHeight: true
                Layout.fillWidth: true
                validator: portRegExp
                onEditingFinished: backend._cduPort = Number(cduPortText.text)
            }

        }

        RowLayout {
            id: ipLayout1
            x: -9
            y: -8
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: 10
            anchors.leftMargin: 40
            Label {
                color: "#000000"
                text: "IP-адрес T_PC:"
                font.pointSize: 20
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                horizontalAlignment: Text.AlignRight
                Layout.fillHeight: true
                Layout.fillWidth: false
                verticalAlignment: Text.AlignVCenter
            }

            TextField {
                id: trainingPcIpAddressText
                text: backend._trainingPcIpAddress
                Layout.minimumWidth: 300
                font.bold: true
                topPadding: 10
                horizontalAlignment: Text.AlignLeft
                Layout.fillHeight: true
                Layout.fillWidth: true
                validator: ipAddressRegExp
                onEditingFinished: backend._trainingPcIpAddress = trainingPcIpAddressText.text
            }

            Label {
                color: "#000000"
                text: ":"
                font.pointSize: 20
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                horizontalAlignment: Text.AlignRight
                Layout.fillHeight: true
                Layout.fillWidth: false
                verticalAlignment: Text.AlignVCenter
            }

            TextField {
                id: trainingPcPortText
                width: 100
                text: backend._trainingPcPort
                Layout.maximumWidth: 100
                font.bold: true
                topPadding: 10
                horizontalAlignment: Text.AlignLeft
                Layout.fillHeight: true
                Layout.fillWidth: true
                validator: portRegExp
                onEditingFinished: backend._trainingPcPort = Number(trainingPcPortText.text)
            }

            anchors.top: ipLayout.bottom
            anchors.rightMargin: 40
            anchors.topMargin: 20
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
}
