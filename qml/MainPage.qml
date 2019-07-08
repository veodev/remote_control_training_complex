import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Window 2.2


Page {
    id: page
    width: 800
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

        Image {
            id: image3
            x: 582
            y: 42
            width: 57
            height: 54
            fillMode: Image.PreserveAspectFit
            source: "../pictures/eye.jpg"
        }

        Image {
            id: leftViewImage
            x: 576
            y: 102
            width: 68
            height: 64
            fillMode: Image.PreserveAspectFit
            source: "../pictures/left.jpg"
            MouseArea {
                anchors.fill: parent
                onReleased: {
                    backend.setOperatorLeftView()
                }
            }
        }

        Image {
            id: centerViewImage
            x: 576
            y: 165
            width: 68
            height: 62
            fillMode: Image.PreserveAspectFit
            source: "../pictures/center.jpg"
            MouseArea {
                anchors.fill: parent
                onReleased: {
                    backend.setOperatorCenterView()
                }
            }
        }

        Image {
            id: rightViewImage
            x: 546
            y: 226
            width: 130
            height: 65
            fillMode: Image.PreserveAspectFit
            source: "../pictures/right.jpg"
            MouseArea {
                anchors.fill: parent
                onReleased: {
                    backend.setOperatorRightView()
                }
            }
        }
    }
    Rectangle {
        id: trackMarkButtonRectangle
        width: 120
        height: 120
        color: "#636363"
        border.color: "#000000"
        border.width: 10
        x: 56
        y: 53
        Button {
            id: trackmarkButton
            width: parent.width - 20 - parent.border.width
            height: parent.height - 20 - parent.border.width
            anchors.centerIn: parent
            background: Rectangle {
                radius: 8;
                color: trackmarkButton.down ? "#292929" : "#000000";
            }
            onReleased: backend.trackMarkButtonReleased();
        }
    }

    Rectangle {
        id: serviceMarkButtonRectangle
        width: 120
        height: 120
        color: "#636363"
        border.color: "#000000"
        border.width: 10
        x: 288
        y: 53

        Button {
            id: serviceMarkButton
            width: parent.width - 20 - parent.border.width
            height: parent.height - 20 - parent.border.width
            anchors.centerIn: parent
            background: Rectangle {
                radius: 8;
                color: serviceMarkButton.down ? "#292929" : "#000000";
            }
            onReleased: backend.serviceMarkButtonReleased();
        }
    }

    Rectangle {
        id: boltJointButtonRectangle
        width: 120
        height: 120
        color: "#636363"
        border.color: "#000000"
        border.width: 10
        x: 56
        y: 187
        Button {
            id: boltJointButton
            width: parent.width - 20 - parent.border.width
            height: parent.height - 20 - parent.border.width
            anchors.centerIn: parent
            background: Rectangle {
                radius: 8;
                color: boltJointButton.down ? "#292929": "#000000";
            }
            onPressed: backend.boltJointButtonPressed();
            onReleased: backend.boltJointButtonReleased();
        }
    }

    Image {
        id: image
        y: 64
        width: 100
        height: 100
        anchors.left: trackMarkButtonRectangle.right
        anchors.leftMargin: 5
        anchors.verticalCenter: trackMarkButtonRectangle.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "../pictures/track_marks_icon.png"
    }

    Image {
        id: image1
        y: 64
        width: 100
        height: 100
        anchors.left: serviceMarkButtonRectangle.right
        anchors.leftMargin: 5
        anchors.verticalCenter: serviceMarkButtonRectangle.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "../pictures/service_marks_icon.png"
        MouseArea {
            anchors.fill: parent
            onPressAndHold: {
                stackView.push(tiltSensorPage)
            }
        }
    }

    Image {
        id: image2
        y: 245
        width: 100
        height: 100
        anchors.left: boltJointButtonRectangle.right
        anchors.leftMargin: 5
        anchors.verticalCenter: boltJointButtonRectangle.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "../pictures/bolt_joint_icon.png"
    }

    Rectangle {
        id: operatorActionsButtonRectangle
        x: 288
        y: 187
        width: 120
        height: 120
        color: "#636363"
        Button {
            id: operatorActionsButton
            width: parent.width - 20 - parent.border.width
            height: parent.height - 20 - parent.border.width
            anchors.centerIn: parent
            background: Rectangle {
                color: operatorActionsButton.down ? "#292929" : "#000000"
                radius: 8
            }
            onReleased: stackView.push(actionsPage)
        }
        border.color: "#000000"
        border.width: 10
    }

    Rectangle {
        id: rectangle
        y: 240
        width: 117
        height: 77
        color: "#00000000"
        radius: 0
        anchors.left: operatorActionsButtonRectangle.right
        anchors.leftMargin: 20
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: operatorActionsButtonRectangle.verticalCenter
        border.width: 3

        Text {
            id: element
            text: qsTr("Действия оператора")
            font.family: "Verdana"
            font.bold: true
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pixelSize: 17
        }

    }
}
