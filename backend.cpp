#include "backend.h"

backend::backend(int port)
{
    udpSocket.bind(QHostAddress::LocalHost, port);

    connect(&udpSocket, &QUdpSocket::readyRead, this, &backend::readPendingDatagrams);
}

void backend::readPendingDatagrams()
{
    struct gps
    {
        float x;
        float y;
    };

    while (udpSocket.hasPendingDatagrams())
    {
        QNetworkDatagram datagram = udpSocket.receiveDatagram();
        gps x = *reinterpret_cast<gps*>(datagram.data().data());
        QGeoCoordinate new_point(x.x, x.y);
        points.append(new_point);
        emit sendToQml(x.x, x.y);
    }
}


