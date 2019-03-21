#include "backend.h"
#include "enums.h"
#include <QDebug>
#include <QTimer>
#include <QtEndian>
#include <math.h>
#ifdef ANDROID
#include <QtAndroidExtras>
#endif

const int PING_INTERVAL_MS = 500;
const int WATCHDOG_INTERVAL_MS = 3000;
const int TILT_SENSOR_READING_INTERVAL_MS = 10;
const float SPEED_FACTOR = 138.8f;
const int MAX_ANGLE_DEGREES = 10;

Backend::Backend(QObject* parent)
    : QObject(parent)
    , _cduTcpSocket(nullptr)
    , _trainingPcTcpSocket(nullptr)
    , _isCduConnect(false)
    , _isTrainingPcConnect(false)
{
#ifdef ANDROID
    keepScreenOn(true);
#endif
    _cduIpAddress = QSettings().value("cduIpAddress", "127.0.0.1").toString();
    _trainingPcIpAddress = QSettings().value("trainingPcIpAddress", "127.0.0.1").toString();
    _cduPort = QSettings().value("cduPort", "49001").toInt();
    _trainingPcPort = QSettings().value("trainingPcPort", "49002").toInt();

    connect(&_cduWatchdog, &QTimer::timeout, this, &Backend::cduWatchdogTimeout);
    _cduWatchdog.setInterval(WATCHDOG_INTERVAL_MS);

    connect(&_cduPingTimer, &QTimer::timeout, this, &Backend::cduPingTimerTimeout);
    _cduPingTimer.setInterval(PING_INTERVAL_MS);

    connect(&_trainingPcWatchdog, &QTimer::timeout, this, &Backend::trainingPcWatchdogTimeout);
    _trainingPcWatchdog.setInterval(WATCHDOG_INTERVAL_MS);

    connect(&_trainingPcPingTimer, &QTimer::timeout, this, &Backend::trainingPcPingTimerTimeout);
    _trainingPcPingTimer.setInterval(PING_INTERVAL_MS);

    connectCdu();
    connectTrainingPc();

    _tiltSensor = new QTiltSensor(this);
    _tiltSensor->start();
    _tiltSensor->connectToBackend();
    connect(&_tiltSensorReadingTimer, &QTimer::timeout, this, &Backend::tiltSensorRead);
    _tiltSensorReadingTimer.setInterval(TILT_SENSOR_READING_INTERVAL_MS);
#ifdef ANDROID
    _tiltSensorReadingTimer.start();
    _tiltSensor->calibrate();
#endif
}

QString& Backend::getCduIpAddress()
{
    return _cduIpAddress;
}

void Backend::setCduIpAddress(QString ipAddress)
{
    _cduIpAddress = ipAddress;
    QSettings().setValue("cduIpAddress", _cduIpAddress);
    qDebug() << _cduIpAddress;
}

quint16 Backend::getCduPort()
{
    return _cduPort;
}

void Backend::setCduPort(quint16 port)
{
    _cduPort = port;
    QSettings().setValue("cduPort", _cduPort);
    qDebug() << _cduPort;
}

QString& Backend::getTrainingPcIpAddress()
{
    return _trainingPcIpAddress;
}

void Backend::setTrainingPcIpAddress(QString ipAddress)
{
    _trainingPcIpAddress = ipAddress;
    QSettings().setValue("trainingPcIpAddress", _trainingPcIpAddress);
    qDebug() << _trainingPcIpAddress;
}

quint16 Backend::getTrainingPcPort()
{
    return _trainingPcPort;
}

void Backend::setTrainingPcPort(quint16 port)
{
    _trainingPcPort = port;
    QSettings().setValue("trainingPcPort", _trainingPcPort);
    qDebug() << _trainingPcPort;
}

void Backend::calibrateTiltSensor()
{
    _tiltSensor->calibrate();
}

void Backend::answerToQuestion(char answer)
{
    QByteArray data;
    data.append(answer);
    sendMessageToTrainingPc(MessageId::AnswerToQuestionId, data);
}

void Backend::action(char operatorAction)
{
    QByteArray data;
    data.append(operatorAction);
    sendMessageToTrainingPc(MessageId::OperatorActionId, data);
}

void Backend::reconnect()
{
    reConnectTrainingPc();
    reConnectCdu();
}

void Backend::trackMarkButtonReleased()
{
    QByteArray data;
    data.append(char(CduMode::TrackMarksMode));
    sendMessageToCdu(MessageId::ChangeCduModeId, data);
}

void Backend::serviceMarkButtonReleased()
{
    QByteArray data;
    data.append(char(CduMode::ServiceMarksMode));
    sendMessageToCdu(MessageId::ChangeCduModeId, data);
}

void Backend::boltJointButtonPressed()
{
    sendMessageToCdu(MessageId::BoltJointOnId);
}

void Backend::boltJointButtonReleased()
{
    sendMessageToCdu(MessageId::BoltJointOffId);
}

void Backend::connectCdu()
{
    if (_cduTcpSocket == nullptr) {
        _cduTcpSocket = new QTcpSocket(this);
        connect(_cduTcpSocket, &QTcpSocket::stateChanged, this, &Backend::cduTcpSocketStateChanged);
        connect(_cduTcpSocket, &QTcpSocket::readyRead, this, &Backend::cduTcpSocketReadyRead);
        _cduTcpSocket->connectToHost(_cduIpAddress, _cduPort);
    }
}

void Backend::disconnectCdu()
{
    if (_cduTcpSocket != nullptr) {
        _cduTcpSocket->disconnectFromHost();
        disconnect(_cduTcpSocket, &QTcpSocket::stateChanged, this, &Backend::cduTcpSocketStateChanged);
        disconnect(_cduTcpSocket, &QTcpSocket::readyRead, this, &Backend::cduTcpSocketReadyRead);
        _cduTcpSocket->deleteLater();
        _cduTcpSocket = nullptr;
    }
}

void Backend::connectTrainingPc()
{
    if (_trainingPcTcpSocket == nullptr) {
        _trainingPcTcpSocket = new QTcpSocket(this);
        connect(_trainingPcTcpSocket, &QTcpSocket::stateChanged, this, &Backend::trainingPcTcpSocketStateChanged);
        connect(_trainingPcTcpSocket, &QTcpSocket::readyRead, this, &Backend::trainingPcTcpSocketReadyRead);
        _trainingPcTcpSocket->connectToHost(_trainingPcIpAddress, _trainingPcPort);
    }
}

void Backend::disconnectTrainingPc()
{
    if (_trainingPcTcpSocket != nullptr) {
        _trainingPcTcpSocket->disconnectFromHost();
        disconnect(_trainingPcTcpSocket, &QTcpSocket::stateChanged, this, &Backend::trainingPcTcpSocketStateChanged);
        disconnect(_trainingPcTcpSocket, &QTcpSocket::readyRead, this, &Backend::trainingPcTcpSocketReadyRead);
        _trainingPcTcpSocket->deleteLater();
        _trainingPcTcpSocket = nullptr;
    }
}

void Backend::reConnectTrainingPc()
{
    disconnectTrainingPc();
    QTimer::singleShot(3000, this, &Backend::connectTrainingPc);
}

void Backend::reConnectCdu()
{
    disconnectCdu();
    QTimer::singleShot(3000, this, &Backend::connectCdu);
}

void Backend::cduTcpSocketStateChanged(QAbstractSocket::SocketState state)
{
    switch (state) {
    case QAbstractSocket::UnconnectedState:
        emit doCduDisconnected();
        disconnectCdu();
        QTimer::singleShot(3000, this, &Backend::connectCdu);
        break;
    case QAbstractSocket::ConnectingState:
        break;
    case QAbstractSocket::ConnectedState:
        _cduPingTimer.start();
        emit doCduConnected();
        break;
    default:
        break;
    }
}

void Backend::cduTcpSocketReadyRead()
{
    _cduMessageBuffer.append(_cduTcpSocket->readAll());
    parseCduMessages();
}

void Backend::trainingPcTcpSocketStateChanged(QAbstractSocket::SocketState state)
{
    switch (state) {
    case QAbstractSocket::UnconnectedState:
        emit doTrainingPcDisconnected();
        disconnectTrainingPc();
        QTimer::singleShot(3000, this, &Backend::connectTrainingPc);
        break;
    case QAbstractSocket::ConnectingState:
        break;
    case QAbstractSocket::ConnectedState:
        _trainingPcPingTimer.start();
        emit doTrainingPcConnected();
        break;
    default:
        break;
    }
}

void Backend::trainingPcTcpSocketReadyRead()
{
    _trainingPcMessageBuffer.append(_trainingPcTcpSocket->readAll());
    parseTrainingPcMessages();
}

void Backend::parseCduMessages()
{
    MessageHeader header;
    while (true) {
        if (_cduMessageBuffer.size() >= static_cast<int>(sizeof(header))) {
            header.Id = static_cast<uchar>(_cduMessageBuffer.at(0));
            header.Size = qFromLittleEndian<ushort>(reinterpret_cast<const uchar*>(_cduMessageBuffer.mid(2, sizeof(ushort)).data()));
            _cduMessageBuffer.remove(0, sizeof(header));
            if (_cduMessageBuffer.size() >= header.Size) {
                switch (static_cast<MessageId>(header.Id)) {
                case MessageId::PingId:
                    _cduWatchdog.start();
                    break;
                default:
                    break;
                }
            }
            else {
                break;
            }
        }
        else {
            break;
        }
    }
}

void Backend::parseTrainingPcMessages()
{
    MessageHeader header;
    while (true) {
        if (_trainingPcMessageBuffer.size() >= static_cast<int>(sizeof(header))) {
            header.Id = static_cast<uchar>(_trainingPcMessageBuffer.at(0));
            header.Size = qFromLittleEndian<ushort>(reinterpret_cast<const uchar*>(_trainingPcMessageBuffer.mid(2, sizeof(ushort)).data()));
            _trainingPcMessageBuffer.remove(0, sizeof(header));
            if (_trainingPcMessageBuffer.size() >= header.Size) {
                switch (static_cast<MessageId>(header.Id)) {
                case MessageId::PingId:
                    _trainingPcWatchdog.start();
                    break;
                case MessageId::ChangeRcModeId:
                    changeRcMode(static_cast<RcMode>(_trainingPcMessageBuffer.at(0)));
                    _trainingPcMessageBuffer.remove(0, 1);
                    break;
                default:
                    break;
                }
            }
            else {
                break;
            }
        }
        else {
            break;
        }
    }
}

void Backend::cduWatchdogTimeout()
{
    _cduPingTimer.stop();
    emit doCduDisconnected();
}

void Backend::cduPingTimerTimeout()
{
    sendMessageToCdu(MessageId::PingId);
}

void Backend::trainingPcWatchdogTimeout()
{
    _trainingPcPingTimer.stop();
    emit doTrainingPcDisconnected();
}

void Backend::trainingPcPingTimerTimeout()
{
    sendMessageToTrainingPc(MessageId::PingId);
}

void Backend::changeRcMode(RcMode mode)
{
    if (mode == RcMode::MainMode) {
        emit doMainMode();
    }
    else if (mode == RcMode::AnswerMode) {
        emit doAnswerMode();
    }
}

void Backend::tiltSensorRead()
{
    _tiltReading = _tiltSensor->reading();
    _tiltMeasures.append(_tiltReading->yRotation());
    if (_tiltMeasures.size() >= 16) {
        double value = std::accumulate(_tiltMeasures.begin(), _tiltMeasures.end(), 0.0) / _tiltMeasures.size();
        float angle = static_cast<float>(std::ceil(value * 2) / 2);
        float speed = angle * SPEED_FACTOR;
        _tiltMeasures.clear();
        emit doTiltXRotationChanged(angle, speed);
        QByteArray data;
        data.append(reinterpret_cast<char*>(&speed), sizeof(speed));
        sendMessageToTrainingPc(MessageId::ManipulatorStateId, data);
    }
}

void Backend::sendMessageToTrainingPc(MessageId messageId, QByteArray data)
{
    if (_trainingPcTcpSocket != nullptr) {
        MessageHeader header;
        header.Id = static_cast<unsigned char>(messageId);
        header.Reserved1 = 0;
        header.Size = static_cast<ushort>(data.size());
        _trainingPcTcpSocket->write(reinterpret_cast<char*>(&header), sizeof(header));
        if (!data.isEmpty()) {
            _trainingPcTcpSocket->write(data);
        }
        _trainingPcTcpSocket->flush();
    }
}

void Backend::sendMessageToCdu(MessageId messageId, QByteArray data)
{
    if (_cduTcpSocket != nullptr) {
        MessageHeader header;
        header.Id = static_cast<unsigned char>(messageId);
        header.Reserved1 = 0;
        header.Size = static_cast<ushort>(data.size());
        _cduTcpSocket->write(reinterpret_cast<char*>(&header), sizeof(header));
        if (!data.isEmpty()) {
            _cduTcpSocket->write(data);
        }
        _cduTcpSocket->flush();
    }
}

#ifdef ANDROID
void Backend::keepScreenOn(bool on)
{
    QtAndroid::runOnAndroidThread([on] {
        QAndroidJniObject activity = QtAndroid::androidActivity();
        if (activity.isValid()) {
            QAndroidJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
            if (window.isValid()) {
                const int FLAG_KEEP_SCREEN_ON = 128;
                if (on) {
                    window.callMethod<void>("addFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
                }
                else {
                    window.callMethod<void>("clearFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
                }
            }
        }
        QAndroidJniEnvironment env;
        if (env->ExceptionCheck()) {
            env->ExceptionClear();
        }
    });
}
#endif
