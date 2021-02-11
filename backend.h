#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QUdpSocket>
#include <QNetworkDatagram>
#include <QDebug>
#include <QtPositioning/QGeoCoordinate>
#include <qqml.h>

class backend: public QObject
{
    Q_OBJECT
    QUdpSocket udpSocket;
public:
    backend(int port);
    QVector<QGeoCoordinate> points;
public slots:
    void readPendingDatagrams();
signals:
    void sendToQml(float x, float y);
};

#endif // BACKEND_H
