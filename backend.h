#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QUdpSocket>
#include <QNetworkDatagram>
#include <QDebug>
#include <QtPositioning/QGeoCoordinate>
#include <qqml.h>
#include "tiffio.h"
#include <QDebug>
#include <QString>

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
    void sendToQmlpoint(float x, float y);
    void sendToQmlimg(float x, float y, QString path);
};

#endif // BACKEND_H
