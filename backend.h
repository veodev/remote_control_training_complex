#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QTcpSocket>
#include <QTimer>
#include <QSettings>
#include <QTiltSensor>
#include <QTiltReading>

#include "enums.h"

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject* parent = nullptr);
    Q_PROPERTY(QString _cduIpAddress READ getCduIpAddress WRITE setCduIpAddress NOTIFY doCduIpAddressChanged)
    QString& getCduIpAddress();
    void setCduIpAddress(QString ipAddress);
    Q_PROPERTY(quint16 _cduPort READ getCduPort WRITE setCduPort NOTIFY doCduPortChanged)
    quint16 getCduPort();
    void setCduPort(quint16 port);
    Q_PROPERTY(QString _trainingPcIpAddress READ getTrainingPcIpAddress WRITE setTrainingPcIpAddress NOTIFY doTrainingPcIpAddressChanged)
    QString& getTrainingPcIpAddress();
    void setTrainingPcIpAddress(QString ipAddress);
    Q_PROPERTY(quint16 _trainingPcPort READ getTrainingPcPort WRITE setTrainingPcPort NOTIFY doTrainingPcPortChanged)
    quint16 getTrainingPcPort();
    void setTrainingPcPort(quint16 port);

    Q_INVOKABLE void calibrateTiltSensor();
    Q_INVOKABLE void answerToQuestion(char answer);
    Q_INVOKABLE void action(char operatorAction);
    Q_INVOKABLE void reconnect();
    Q_INVOKABLE void trackMarkButtonReleased();
    Q_INVOKABLE void serviceMarkButtonReleased();
    Q_INVOKABLE void boltJointButtonPressed();
    Q_INVOKABLE void boltJointButtonReleased();
    Q_INVOKABLE void setDebugMode(bool isDebug);
    Q_INVOKABLE void changeAngle(float addition);
    Q_INVOKABLE void changeMotionMode(bool isMotion);
    Q_INVOKABLE void setOperatorCenterView();
    Q_INVOKABLE void setOperatorLeftView();
    Q_INVOKABLE void setOperatorRightView();

signals:
    void doCduConnected();
    void doCduDisconnected();
    void doTrainingPcConnected();
    void doTrainingPcDisconnected();
    void doMainMode();
    void doAnswerMode();
    void doCduIpAddressChanged();
    void doTrainingPcIpAddressChanged();
    void doCduPortChanged();
    void doTrainingPcPortChanged();
    void doTiltXRotationChanged(float angle, float speed);

private:
#ifdef ANDROID
    void keepScreenOn(bool on);
#endif
    void connectCdu();
    void disconnectCdu();
    void connectTrainingPc();
    void disconnectTrainingPc();
    void reConnectTrainingPc();
    void reConnectCdu();
    void cduTcpSocketStateChanged(QAbstractSocket::SocketState state);
    void cduTcpSocketReadyRead();
    void trainingPcTcpSocketStateChanged(QAbstractSocket::SocketState state);
    void trainingPcTcpSocketReadyRead();
    void parseCduMessages();
    void parseTrainingPcMessages();
    void cduWatchdogTimeout();
    void cduPingTimerTimeout();
    void trainingPcWatchdogTimeout();
    void trainingPcPingTimerTimeout();
    void changeRcMode(RcMode mode);
    void tiltSensorRead();
    void sendMessageToTrainingPc(MessageId messageId, QByteArray data = QByteArray());
    void sendMessageToCdu(MessageId messageId, QByteArray data = QByteArray());
    float correctAngleValue(float angle);

private:
    QTcpSocket* _cduTcpSocket;
    QTcpSocket* _trainingPcTcpSocket;

    QByteArray _cduMessageBuffer;
    QByteArray _trainingPcMessageBuffer;

    QTimer _cduWatchdog;
    QTimer _trainingPcWatchdog;

    QTimer _cduPingTimer;
    QTimer _trainingPcPingTimer;

    bool _isCduConnect;
    bool _isTrainingPcConnect;
    bool _isDebugMode;
    bool _isMotion;

    QString _cduIpAddress;
    QString _trainingPcIpAddress;
    quint16 _cduPort;
    quint16 _trainingPcPort;

    QTiltSensor* _tiltSensor;
    QTiltReading* _tiltReading;

    QTimer _tiltSensorReadingTimer;
    QVector<qreal> _tiltMeasures;
    float _debugAngle;
};

#endif  // BACKEND_H
