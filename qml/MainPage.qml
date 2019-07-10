import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Window 2.2


Page {
    id: page
    width: 670

    property bool isViewCenter: true
    property bool isViewLeft: false
    property bool isViewRight: false

    Rectangle {
        id: rcRectangle
        visible: true
        border.color: "black"
        border.width: 30
        radius: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        gradient: Gradient {
            GradientStop {position: 0; color: "#ffffff";}
            GradientStop {position: 0.5; color: "#ababab"}
            GradientStop {position: 1; color: "#ffffff";}
        }

        Image {
            id: eyeImage
            x: 484
            y: 46
            width: 100
            height: 44
            fillMode: Image.PreserveAspectFit
            source: "../pictures/eye.png"
        }

        Image {
            id: leftViewImage
            x: 621
            y: 109
            width: 110
            height: 50
            fillMode: Image.PreserveAspectFit
            source: "../pictures/left_released.png"
            anchors.horizontalCenter: eyeImage.horizontalCenter
            MouseArea {
                anchors.fill: parent
                onReleased: {
                    if (!isViewLeft) {
                        backend.setOperatorLeftView();
                        leftViewImage.source = "../pictures/left_pressed.png";
                        centerViewImage.source = "../pictures/center_released.png";
                        rightViewImage.source = "../pictures/right_released.png";
                        isViewLeft = true;
                        isViewRight = false;
                        isViewCenter = false;
                    }
                }
            }
        }

        Image {
            id: centerViewImage
            x: 631
            y: 165
            width: 100
            height: 61
            fillMode: Image.PreserveAspectFit
            source: "../pictures/center_pressed.png"
            anchors.horizontalCenter: eyeImage.horizontalCenter
            MouseArea {
                anchors.fill: parent
                onReleased: {
                    if (!isViewCenter) {
                        backend.setOperatorCenterView();
                        centerViewImage.source = "../pictures/center_pressed.png";
                        leftViewImage.source = "../pictures/left_released.png";
                        rightViewImage.source = "../pictures/right_released.png";
                        isViewCenter = true;
                        isViewLeft = false;
                        isViewRight = false;
                    }
                }
            }
        }

        Image {
            id: rightViewImage
            x: 616
            y: 240
            width: 130
            height: 50
            fillMode: Image.PreserveAspectFit
            source: "../pictures/right_released.png"
            anchors.horizontalCenter: eyeImage.horizontalCenter
            MouseArea {
                anchors.fill: parent
                onReleased: {
                    if (!isViewRight) {
                        backend.setOperatorRightView()
                        rightViewImage.source = "../pictures/right_pressed.png";
                        centerViewImage.source = "../pictures/center_released.png";
                        leftViewImage.source = "../pictures/left_released.png";
                        isViewRight = true;
                        isViewLeft = false;
                        isViewCenter = false;
                    }
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
        x: 267
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
        width: 80
        height: 80
        anchors.left: trackMarkButtonRectangle.right
        anchors.leftMargin: 5
        anchors.verticalCenter: trackMarkButtonRectangle.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "../pictures/track_marks_icon.png"
    }

    Image {
        id: image1
        y: 64
        width: 80
        height: 80
        anchors.left: serviceMarkButtonRectangle.right
        anchors.leftMargin: 5
        anchors.verticalCenter: serviceMarkButtonRectangle.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "../pictures/service_marks_icon.png"
        MouseArea {
            width: 80
            height: 80
            anchors.fill: parent
            onPressAndHold: {
                stackView.push(tiltSensorPage)
            }
        }
    }

    Image {
        id: image2
        y: 245
        width: 80
        height: 80
        anchors.left: boltJointButtonRectangle.right
        anchors.leftMargin: 5
        anchors.verticalCenter: boltJointButtonRectangle.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "../pictures/bolt_joint_icon.png"
    }

    Rectangle {
        id: operatorActionsButtonRectangle
        x: 267
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
        width: 89
        height: 68
        color: "#00000000"
        radius: 0
        anchors.left: operatorActionsButtonRectangle.right
        anchors.leftMargin: 14
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
            font.pixelSize: 12
        }

    }
}
