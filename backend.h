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
    void connectCdu();
    void disconnectCdu();
    void connectTrainingPc();
    void disconnectTrainingPc();
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
#ifdef ANDROID
    void keepScreenOn(bool on);
#endif

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

    QString _cduIpAddress;
    QString _trainingPcIpAddress;
    quint16 _cduPort;
    quint16 _trainingPcPort;

    QTiltSensor* _tiltSensor;
    QTiltReading* _tiltReading;

    QTimer _tiltSensorReadingTimer;
    QVector<qreal> _tiltMeasures;
};

#endif  // BACKEND_H
